function [gFFT_target_Signal,gFFT_target_Noise,contracted_finalMask_gFFT_target_isolationEliminated] = DASHFFT_SNImgGeneration_2D(fundamentalHarmonicsOrder,maskData,gFFT_target,frameNoImages)
% function [gFFT_target_Signal,gFFT_target_Noise,contracted_finalMask_gFFT_target_isolationEliminated] = DASHFFT_SNImgGeneration_2D(fundamentalHarmonicsOrder,maskData,gFFT_target)
% Generates signal and noise images from mask data generated using
% DASHFFT_SNImgGeneration_2D.m



%
% Test show plots at specific row/frame
% Run after finishing DASH_analysis_runtest_2D_Zigzag.m
%

%global movieFPS
%global frameNoImages

% Allow maximum +- frequencyWindow [Hz] for counting for the signal
% usually signal frequencies are picked based on FWHM (Full width Half
% maximum), but we need to neglect the "skirts" if it becomes too wide
% (= signal cannot be distinguished with the noise - almost same amplitude)

%frequencyWindow

%Order of Fundamental + Harmonics we are going to count
%fundamentalHarmonicsOrder



%load base mask data
load(maskData);%<--need to generate new mask depending on the values of frequencyWindow and fundamentalHarmonicsOrder. Use TestShow_Snr_2D_Createmask.m to create mask


% list up Candidates of signal points
% selectionTargetPointMaskP size -> [gFFT_2dA0_sizeX,gFFT_2dA0_sizeY,2,fundamentalHarmonicsOrder]
% selectionTargetPointMaskM size -> [gFFT_2dA0_sizeX,gFFT_2dA0_sizeY,2,fundamentalHarmonicsOrder

% ImplayWithMap(selectionTargetPointMaskP(:,:,1,:),[0 1],'gray',1);
% ImplayWithMap(selectionTargetPointMaskM(:,:,1,:),[0 1],'gray',1);
% ImplayWithMap(selectionTargetPointMaskP(:,:,2,:),[0 1],'gray',1);
% ImplayWithMap(selectionTargetPointMaskM(:,:,2,:),[0 1],'gray',1);

for  harmonicsIndex = 1:fundamentalHarmonicsOrder
[rowP1,colP1,v] = find(selectionTargetPointMaskP(:,:,1,harmonicsIndex));
[rowP2,colP2,v] = find(selectionTargetPointMaskP(:,:,2,harmonicsIndex));
[rowM1,colM1,v] = find(selectionTargetPointMaskM(:,:,1,harmonicsIndex));
[rowM2,colM2,v] = find(selectionTargetPointMaskM(:,:,2,harmonicsIndex));

selectionTargetPointMaskPList(:,:,1,harmonicsIndex) = [rowP1,colP1];
selectionTargetPointMaskPList(:,:,2,harmonicsIndex) = [rowP2,colP2];
selectionTargetPointMaskMList(:,:,1,harmonicsIndex) = [rowM1,colM1];
selectionTargetPointMaskMList(:,:,2,harmonicsIndex) = [rowM2,colM2];

end


%prepare target gFFT data
% change from complex to abs
gFFT_target = abs(gFFT_target);
[gFFT_target_sizeX,gFFT_target_sizeY,gFFT_target_sizeZ] = size(gFFT_target);


%initialize final mask data for gFFT
% [gFFT_target_sizeX,gFFT_target_sizeY,1 or 2 ,P(1) or M(2),harmonicsIndex,frameNoImages]
finalMask_gFFT_target = zeros(gFFT_target_sizeX,gFFT_target_sizeY,2,2,fundamentalHarmonicsOrder,frameNoImages);

for frame = 1:frameNoImages
    for  harmonicsIndex = 1:fundamentalHarmonicsOrder
        
        %1,P
        finalMask_gFFT_target(:,:,1,1,harmonicsIndex,frame) = selectionTargetPointMaskP(:,:,1,harmonicsIndex);
        %2,P
        finalMask_gFFT_target(:,:,2,1,harmonicsIndex,frame) = selectionTargetPointMaskP(:,:,2,harmonicsIndex);
        %1,M
        finalMask_gFFT_target(:,:,1,2,harmonicsIndex,frame) = selectionTargetPointMaskM(:,:,1,harmonicsIndex);
        %2,M
        finalMask_gFFT_target(:,:,2,2,harmonicsIndex,frame) = selectionTargetPointMaskM(:,:,2,harmonicsIndex);
        
        
    end
end




%calculate size of the candidate point list -- always size should be the
%same
[selectionTargetPointMaskList_sizeX,k,l,m] = size(selectionTargetPointMaskPList);
%[selectionTargetPointMaskMList_sizeX,k,l,m] = size(selectionTargetPointMaskPList);

%update mask info by comparing values in candidate point list vs
%selection target point
for frame = 1:frameNoImages
    for  harmonicsIndex = 1:fundamentalHarmonicsOrder
        for targetPointList = 1:selectionTargetPointMaskList_sizeX
            
            %if values are below 50%, then change the mask value to 0
            
            %1,P
            if gFFT_target(selectionTargetPointMaskPList(targetPointList,1,1,harmonicsIndex),selectionTargetPointMaskPList(targetPointList,2,1,harmonicsIndex),frame) ...
                   < 0.5 .* gFFT_target(selectionTargetPointP(1,1,harmonicsIndex),selectionTargetPointP(1,2,harmonicsIndex),frame)
                
                finalMask_gFFT_target(selectionTargetPointMaskPList(targetPointList,1,1,harmonicsIndex),selectionTargetPointMaskPList(targetPointList,2,1,harmonicsIndex),1,1,harmonicsIndex,frame) = 0;
            end
            
            %2,P
            if gFFT_target(selectionTargetPointMaskPList(targetPointList,1,2,harmonicsIndex),selectionTargetPointMaskPList(targetPointList,2,2,harmonicsIndex),frame) ...
                    < 0.5.* gFFT_target(selectionTargetPointP(2,1,harmonicsIndex),selectionTargetPointP(2,2,harmonicsIndex),frame)
                
                finalMask_gFFT_target(selectionTargetPointMaskPList(targetPointList,1,2,harmonicsIndex),selectionTargetPointMaskPList(targetPointList,2,2,harmonicsIndex),2,1,harmonicsIndex,frame) = 0;
            end
            
            
            %1,M
            if gFFT_target(selectionTargetPointMaskMList(targetPointList,1,1,harmonicsIndex),selectionTargetPointMaskMList(targetPointList,2,1,harmonicsIndex),frame) ...
                    < 0.5.* gFFT_target(selectionTargetPointM(1,1,harmonicsIndex),selectionTargetPointM(1,2,harmonicsIndex),frame)
                
                finalMask_gFFT_target(selectionTargetPointMaskMList(targetPointList,1,1,harmonicsIndex),selectionTargetPointMaskMList(targetPointList,2,1,harmonicsIndex),1,2,harmonicsIndex,frame) = 0;
            end
            
            %2,M
            if gFFT_target(selectionTargetPointMaskMList(targetPointList,1,2,harmonicsIndex),selectionTargetPointMaskMList(targetPointList,2,2,harmonicsIndex),frame) ...
                    < 0.5.* gFFT_target(selectionTargetPointM(2,1,harmonicsIndex),selectionTargetPointM(2,2,harmonicsIndex),frame)
                
                finalMask_gFFT_target(selectionTargetPointMaskMList(targetPointList,1,2,harmonicsIndex),selectionTargetPointMaskMList(targetPointList,2,2,harmonicsIndex),2,2,harmonicsIndex,frame) = 0;
            end
            
            
            
        end
    end 
end


%contract masks into one file per frame

contracted_finalMask_gFFT_target = zeros(gFFT_target_sizeX,gFFT_target_sizeY,frameNoImages);
for frame = 1:frameNoImages
    for  harmonicsIndex = 1:fundamentalHarmonicsOrder
        contracted_finalMask_gFFT_target(:,:,frame) = contracted_finalMask_gFFT_target(:,:,frame) + ...
          finalMask_gFFT_target(:,:,1,1,harmonicsIndex,frame) + ...
          finalMask_gFFT_target(:,:,2,1,harmonicsIndex,frame) + ...
          finalMask_gFFT_target(:,:,1,2,harmonicsIndex,frame) + ...
          finalMask_gFFT_target(:,:,2,2,harmonicsIndex,frame);
    end
end

%ImplayWithMap(contracted_finalMask_gFFT_target,[0 1],'gray',movieFPS);


%eliminate isolated region (keep only regions around target point)

contracted_finalMask_gFFT_target_isolationEliminated = contracted_finalMask_gFFT_target;

%create temporary list of all target points
tempAllTargetPoints = [NaN,NaN];
for  harmonicsIndex = 1:fundamentalHarmonicsOrder
    tempAllTargetPoints = [tempAllTargetPoints; selectionTargetPointP(:,:,harmonicsIndex)];
    tempAllTargetPoints = [tempAllTargetPoints; selectionTargetPointM(:,:,harmonicsIndex)];
end

%search and fill starting each points in the mask with positive value, compare whether those points
%include original dash frequency target points
for frame = 1:frameNoImages
    [row,col,v] = find(contracted_finalMask_gFFT_target(:,:,frame));
    
    for points = 1:size(row,1)
        startPointX = row(points);
        startPointY = col(points);
        maskTemp = imfill(~contracted_finalMask_gFFT_target(:,:,frame),[startPointX startPointY]);
        maskTemp = maskTemp - ~contracted_finalMask_gFFT_target(:,:,frame);
        locationsFilled = find(maskTemp);
        [locationsFilledArrayX,locationsFilledArrayY] = ind2sub([gFFT_target_sizeX gFFT_target_sizeY],locationsFilled.');
        locationIncludesTargetPoints = ismember([locationsFilledArrayX.', locationsFilledArrayY.'],tempAllTargetPoints,'rows');
        locationIncludesTargetPointsTF = sum(sum(locationIncludesTargetPoints));
        
        % eliminate the locationif the area does not include TargetPoint ( = isolated region)
        if locationIncludesTargetPointsTF == 0
            contracted_finalMask_gFFT_target_isolationEliminated(locationsFilledArrayX.',locationsFilledArrayY.',frame) = 0;
        end
        
    end
    disp(['.']);
end

% contracted_finalMask_gFFT_target_isolationEliminated
%is the final mask data for calculation


%Generate signal array and noise array (output)
gFFT_target_Signal = gFFT_target.*contracted_finalMask_gFFT_target_isolationEliminated;
gFFT_target_Noise = gFFT_target.*(~contracted_finalMask_gFFT_target_isolationEliminated);

end







