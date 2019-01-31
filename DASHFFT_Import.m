function [angle, xOrigin,yOrigin,backgroundXCenter,backgroundYCenter, geoFlag, channelWidthPx, channelLengthPx, gImageFixCrop, bwImageFixAdjustCrop,gBkgrnd,frameNoImages] = DASHFFT_Import(gFilePath, bwFilePath, StabCoordX, StabCoordY)
% DASHFFT_Import Imports Raw Tiff Images (g,bf) for DASH Analysis
% Add files to the workspace from gFilePath, bwFilePath
% [angle, xOrigin,yOrigin,sqXOrigin,sqYOrigin,, geoFlag, channelWidthPx, channelLengthPx, gImageFixCrop, bwImageFixAdjustCrop] = DASHFFT_Import(gFilePath, bwFilePath)
% 



%% Define global variables
global channelWidth_50Stag
global channelLength_50Stag
global channelWidth_ZigZag
global channelLength_ZigZag
global channelWidth_ZigZag_min
global channelWidth_Dia
global channelLength_Dia

global ImageScale

global x_remove_50Stag
global x_remove_ZigZag

global movieFPS

%global frameNoImages



%% READ TWO IMAGES

gInfoImage = imfinfo(gFilePath); % load tiff image info
bwInfoImage = imfinfo(bwFilePath);

mImage=gInfoImage(1).Width;% import width/height/frame information from G channel
nImage=gInfoImage(1).Height;
frameNoImages=length(gInfoImage);

gImage=zeros(nImage,mImage,frameNoImages);
bwImage=zeros(nImage,mImage,frameNoImages);

 disp(['Loading Image frame:']);
for i=1:frameNoImages  
    disp(num2str(i));
	gImage(:,:,i)=imread(gFilePath,i);
	bwImage(:,:,i)=imread(bwFilePath,i);
end

gImage = mat2gray(im2double(gImage));   % Converts img to double
bwImage = mat2gray(im2double(bwImage));   % Converts img to double

disp(['Files Imported.']);



%
%% PRE-PROCESS (Rotate, select geometry)
%

disp(['Starting Pre-process...']);

% Remove Background Intensity (G): Choose small section of green image, do gBkgrnd = mean2(section) to find
% avg. background intensity
% user chooses origin of 10x10 square for background subtraction

gBkgrnd = zeros(frameNoImages);
gImageAdjust = imadjust(gImage(:,:,frameNoImages));

bwgImageOverlay = imfuse(gImageAdjust,bwImage(:,:,frameNoImages),'blend','Scaling','joint');
figure,imshow(bwgImageOverlay); title('Choose Center coordinate for the Background Subtraction (+- 5px from center will be used)');
[backgroundXCenter,backgroundYCenter] = ginput(1);

close all


disp(['Background processing...']);
for i=1:frameNoImages
    disp(num2str(i));
    gBkgrndSample = gImage(int64(backgroundYCenter-5):int64(backgroundYCenter+5),int64(backgroundXCenter-5):int64(backgroundXCenter+5),i);
    gBkgrnd(i) = mean2(gBkgrndSample);
    gImage(:,:,i) = gImage(:,:,i)-gBkgrnd(i);
end


%ROTATE images using Background BW image
%measure rotation angle
angle = horizon(bwImage(:,:,1), 0.1, 'fft');     

%Test rotation (only first frame -- to measure new width/height of the image)
bwImageFixTest =  imrotate(bwImage(:,:,1), -angle, 'bicubic');
[ImageFixSizeX,ImageFixSizeY] = size(bwImageFixTest);

gImageFixAdjust=zeros(ImageFixSizeX,ImageFixSizeY,frameNoImages);
bwImageFixAdjust=zeros(ImageFixSizeX,ImageFixSizeY,frameNoImages);
disp(['Rotation fix...']);
for i=1:frameNoImages
    disp(num2str(i));
    gImageFix(:,:,i) =  imrotate(gImage(:,:,i), -angle, 'bicubic');
    bwImageFix(:,:,i) =  imrotate(bwImage(:,:,i), -angle, 'bicubic');
end

% <Imported images>
% gImageFix ... GR channel image (w corrected angle)
% bwImageFix ... BW channel image (w corrected angle)
%

bwImageFixAdjust=zeros(ImageFixSizeX,ImageFixSizeY,frameNoImages);
disp(['Adjusting BW contrast...']);
for i=1:frameNoImages 
    disp(num2str(i));
bwImageFixAdjust(:,:,i) = imadjust(bwImageFix(:,:,i)); % Adjust BW contrast for cropping
end

figure,imshow(bwImageFixAdjust(:,:,1)); title('Choose Origin of Image (top-left edge of the pillar region)');
[xOrigin,yOrigin] = ginput(1);

geoFlag = menu('Device Type','50 Staggered WITH Pillar Lane Deletion',...
                             '2-D Zig-zag WITH Pillar Lane Deletion',...
                             '50 Staggered with NO Pillar Lane Deletion',...
                             '2-D Zig-zag with NO Pillar Lane Deletion',...
                             '1-D Diamond with NO Pillar Lane Deletion',...
                             '2-D Zig-zag (150um min width) with NO Pillar Lane Deletion');
close all

disp(['Device: ' num2str(geoFlag) ' selected.']);

% set image width/length parameters depending on the geometry
if (geoFlag==1) % 50 stag.
    channelWidth = channelWidth_50Stag;
    channelLength = channelLength_50Stag;
elseif(geoFlag == 2)
    channelWidth = channelWidth_ZigZag;
    channelLength = channelLength_ZigZag;
elseif(geoFlag == 3)
    channelWidth = channelWidth_50Stag;
    channelLength = channelLength_50Stag;
elseif(geoFlag == 4)
    channelWidth = channelWidth_ZigZag;
    channelLength = channelLength_ZigZag;
elseif(geoFlag == 5)
    channelWidth = channelWidth_Dia;
    channelLength = channelLength_Dia;
else
    channelWidth = channelWidth_ZigZag_min;
    channelLength = channelLength_ZigZag;
end

channelWidthPx = round(channelWidth./ImageScale); %Channel width in pixel (rounded)
channelLengthPx = round(channelLength./ImageScale); %Channel length in pixel (rounded)

%initialize cropped image array
gImageFixCrop = zeros(channelWidthPx,channelLengthPx,frameNoImages);
bwImageFixAdjustCrop = zeros(channelWidthPx,channelLengthPx,frameNoImages);

% crop based on geometry information
% if stabilization info flag is on, then 
disp(['Cropping...']);
for k =1:frameNoImages
    disp(num2str(k));
    yO = yOrigin+StabCoordY(k);
    xO = xOrigin+StabCoordX(k);
    gImageFixCrop(:,:,k) = gImageFix(int64(yO):int64(yO+channelWidthPx-1),int64(xO):int64(xO+channelLengthPx-1),k);% CROP G image
    bwImageFixAdjustCrop(:,:,k) = bwImageFixAdjust(int64(yO):int64(yO+channelWidthPx-1),int64(xO):int64(xO+channelLengthPx-1),k);% CROP bw image
end


%gImageFixCrop(:,:,:) = gImageFix(int64(yOrigin):int64(yOrigin+channelWidthPx-1),int64(xOrigin):int64(xOrigin+channelLengthPx-1),:);% CROP G image
%bwImageFixAdjustCrop(:,:,:) = bwImageFixAdjust(int64(yOrigin):int64(yOrigin+channelWidthPx-1),int64(xOrigin):int64(xOrigin+channelLengthPx-1),:); % CROP BW image
    






% black out pillar region
if (geoFlag==1) % 50 stag.
    
    gImageFixCrop(:,x_remove_50Stag,:) = 0;

elseif(geoFlag == 2)
    
    gImageFixCrop(:,x_remove_ZigZag,:) = 0;
    
else
    Img = Img; %temp        
end

%ImplayWithMap(gImageFixCrop,[0 1],'jet',movieFPS);
%ImplayWithMap(bwImageFixAdjustCrop,[0 1],'gray',movieFPS);

% <Final cropped/adjusted images>
% gImageFixCrop ... G channel image WITHOUT PILLAR REGIONS (w corrected angle, cropped from ORIGIN)
% bwImageFixAdjustCrop ... BW channel image (w corrected angle, adjusted contrast, cropped from ORIGIN)




end