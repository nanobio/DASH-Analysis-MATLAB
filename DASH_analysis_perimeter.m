%%
%% Perimeter Analysis (For quasi-locomotion)
%% Run import_example first
%% 04062018 Shogo Hamada
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

binaryThreshold = 0.015;

%Create the binary image based on binaryThreshold
gImageFixCrop_W1_BW = imbinarize(gImageFixCrop_W1,binaryThreshold);


% Fill the holes inside the binary image
gImageFixCrop_W1_BW_filled = NaN(size(gImageFixCrop_W1_BW));

for i = 1:size(gImageFixCrop_W1_BW,3)
gImageFixCrop_W1_BW_filled(:,:,i) = imfill(gImageFixCrop_W1_BW(:,:,i),'holes');
end

ImplayWithMap(gImageFixCrop_W1_BW_filled,[0 1],'hot',movieFPS);



%Pick the largest region
gImageFixCrop_W1_BW_filled_largest = NaN(size(gImageFixCrop_W1_BW));

for i = 1:size(gImageFixCrop_W1_BW,3)
gImageFixCrop_W1_BW_filled_largest(:,:,i) = bwareafilt(logical(gImageFixCrop_W1_BW_filled(:,:,i)),1);
end

ImplayWithMap(gImageFixCrop_W1_BW_filled_largest,[0 1],'hot',movieFPS);









