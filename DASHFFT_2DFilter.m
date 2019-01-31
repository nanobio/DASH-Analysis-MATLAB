function [gFFT_vFiltered, filterFreq, selectionFreqPoint] = DASHFFT_2DFilter(gFFT_v, geoFlag, freqPick)

global filterFreq_50Stag
global filterFreq_ZigZag_2D

disp(['Filtering FFT Image by DASH Frequency...']);
disp(['Pixels selected:']);

% Filter out only graph values for DASH frequency peaks
gFFT_vFiltered = gFFT_v;
[gFFT_vFiltered_sizeX,gFFT_vFiltered_sizeY,gFFT_vFiltered_sizeZ] = size(gFFT_vFiltered);


% define filterFreq = [x,y]; 

%set DASH frequency to filter out
if geoFlag == 1 %50 staggered
    filterFreq = [filterFreq_50Stag,0];
elseif geoFlag == 2
    filterFreq = filterFreq_ZigZag_2D;
elseif  geoFlag == 3
    filterFreq = [filterFreq_50Stag,0];
else
    filterFreq = filterFreq_ZigZag_2D;
end



% pick corresponding frequency
if freqPick == '+'
    
    for j = 1: gFFT_vFiltered_sizeY
        for i = 1: gFFT_vFiltered_sizeX
            if     [i,j] == [round(gFFT_vFiltered_sizeX ./2 + 1 - filterFreq(1)), round(gFFT_vFiltered_sizeY ./2 + 1 - filterFreq(2))]
                disp(['[' num2str(i) ',' num2str(j) ']'])
            elseif [i,j] == [round(gFFT_vFiltered_sizeX ./2 + 1 + filterFreq(1)), round(gFFT_vFiltered_sizeY ./2 + 1 + filterFreq(2))]
                disp(['[' num2str(i) ',' num2str(j) ']'])
            else
            gFFT_vFiltered(i,j,:) = 0;
            end     
        end
    end
    
    selectionFreqPoint = [round(gFFT_vFiltered_sizeX ./2 + 1 - filterFreq(1)), round(gFFT_vFiltered_sizeY ./2 + 1 - filterFreq(2)); round(gFFT_vFiltered_sizeX ./2 + 1 + filterFreq(1)), round(gFFT_vFiltered_sizeY ./2 + 1 + filterFreq(2))];
    
    
elseif  freqPick == '-'
    
    for j = 1: gFFT_vFiltered_sizeY
        for i = 1: gFFT_vFiltered_sizeX
            if [i,j] == [round(gFFT_vFiltered_sizeX ./2 + 1 + filterFreq(1)), round(gFFT_vFiltered_sizeY ./2 + 1 - filterFreq(2))]
                disp(['[' num2str(i) ',' num2str(j) ']'])
            elseif [i,j] == [round(gFFT_vFiltered_sizeX ./2 + 1 - filterFreq(1)), round(gFFT_vFiltered_sizeY ./2 + 1 + filterFreq(2))]
        	    disp(['[' num2str(i) ',' num2str(j) ']'])
            else
            gFFT_vFiltered(i,j,:) = 0;
            end     
        end
    end    
    
    selectionFreqPoint = [round(gFFT_vFiltered_sizeX ./2 + 1 + filterFreq(1)), round(gFFT_vFiltered_sizeY ./2 + 1 - filterFreq(2)); round(gFFT_vFiltered_sizeX ./2 + 1 - filterFreq(1)), round(gFFT_vFiltered_sizeY ./2 + 1 + filterFreq(2))];
    
else
    %no filtering
    selectionFreqPoint = 0;
end



disp(['Filtering DASH frequency completed.']);



end