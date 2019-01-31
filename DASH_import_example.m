%%
%% Data Import (Example script)
%% 12262017 Shogo Hamada
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear;

%% Define global variables
global channelWidth_50Stag
global channelLength_50Stag
global channelWidth_ZigZag
global channelLength_ZigZag
global channelWidth_ZigZag_min
global ImageScale
global filterFreq_50Stag
global filterFreq_ZigZag
%global filterFreq
global x_remove_50Stag
global x_remove_ZigZag
global oneDFFTImThres
global twoDFFTImThres
global movieFPS
global oneDinvFFTImThres

% global frameNoImages
global frameNoImages_default

global startYPxA
global startYPxB


%% Device data 
DASHFFT_Dataload();


%Load Observed Data Info
gFilePath_W1 =  'foo.tiff';% <----------- SELECT FLUORES. (GREEN) IMAGE
bwFilePath_W1 = 'bar.tiff'; % <----------- SELECT BACKGROUND (BW) IMAGE
StabCoordX_W1 = zeros(289,1);
StabCoordY_W1 = zeros(289,1);


%% Data Import
[angle_W1, xOrigin_W1,yOrigin_W1,backgroundXCenter_W1,backgroundYCenter_W1, geoFlag_W1, channelWidthPx_W1, channelLengthPx_W1, gImageFixCrop_W1, bwImageFixAdjustCrop_W1,gBkgrnd_W1,frameNoImages_W1] ...
    = DASHFFT_Import(gFilePath_W1, bwFilePath_W1, StabCoordX_W1, StabCoordY_W1);









