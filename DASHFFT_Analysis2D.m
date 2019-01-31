function [gImageTarget, gFFT_2d, rangeYFFT] = DASHFFT_Analysis2D( gImageFixCrop, channelWidthPx, startYPx, frameNoImages)
% DASHFFT_Analysis2D 2-D FFT Conversion of gImageFixCrop image 
% [gFFT_v] = DASHFFT_Analysis2D( gImageFixCrop, channelLengthPx)
%

%% Define global variables

%global frameNoImages
global movieFPS

%
%% FFT analysis
%

disp(['Starting 2-D FFT analysis...']);

%define gImageFFT

gImageTarget =  gImageFixCrop(:, startYPx:startYPx+channelWidthPx-1 , :);

ImplayWithMap(gImageTarget,[0 1],'jet',movieFPS);

%set the range of freq. domain
rangeXFFT = 2*channelWidthPx;% x axis
rangeYFFT = 2*channelWidthPx;% x axis
%rangeYFFT = 2*channelLengthPx;%y axis -- for 2-D FFT

%2-d fft analysis
gFFT_2d = zeros(rangeXFFT,rangeYFFT,frameNoImages);
for i=1:frameNoImages
    gFFT_2d(:,:,i) = fftshift(fft2(gImageTarget(:,:,i),rangeXFFT,rangeYFFT));
   
end
    
disp(['2-D FFT Conversion completed.']);

end


