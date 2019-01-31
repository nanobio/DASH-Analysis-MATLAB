function [] = DASHFFT_Dataload()

%% Define global variables
global channelWidth_50Stag
global channelLength_50Stag
global channelWidth_ZigZag
global channelLength_ZigZag
global channelWidth_ZigZag_min
global channelWidth_Dia
global channelLength_Dia

global ImageScale
global filterFreq_50Stag
global filterFreq_ZigZag
global filterFreq_ZigZag_2D

global x_remove_50Stag
global x_remove_ZigZag
global oneDFFTImThres
global twoDFFTImThres
global movieFPS
global oneDinvFFTImThres


%global frameNoImages
global frameNoImages_default

%% Device data 
%50 stag
channelWidth_50Stag = 500;%[um] Channel width
channelLength_50Stag = 1910;%[um] Channel length

%2-D Hex-weaving ZigZag (9-1)
channelWidth_ZigZag = 500;%[um] Channel width
channelLength_ZigZag = 1930;%[um] Channel length

channelWidth_ZigZag_min = 150;%[um] Channel width

%1-D Diamond
channelWidth_Dia = 500;%[um] Channel width
channelLength_Dia = 1930;%[um] Channel length

% Image scale
ImageScale = 1.6125;%[um] per px

%DASH Frequency
filterFreq_50Stag = 15; % no. of DASH line in device (converted to frequency)
filterFreq_ZigZag = 20; % 1-D version

filterFreq_ZigZag_2D = [20, 5];

%Pillar removal region [px]
%only for 50stag. now, but x_remove changes for EACH DEVICE
%1.6125 um per pix

x_remove_50Stag = [1:17 42:60 85:103 128:146 172:188 215:231 258:274 301:317 343:360 ...
        386:403 429:448 472:492 516:534 558:576 600:619 643:660 686:703 730:747 ...
        773:790 816:832 859:876 902:919 944:961 987:1004 1032:1051 1074:1091 1116:1134 1159:1176];

x_remove_ZigZag = [1:20 61:82 122:144 184:205 246:266 307:328 368:389 430:451 ... 
        491:512 553:574 614:635 676:697 737:759 798:820 860:881 922:943 983:1004 ...
        1045:1066 1107:1128 1168:1189];
    
%1-D FFT image threshold
oneDFFTImThres = 1;

%2-D FFT image threshold
twoDFFTImThres = 1500;

%Movie FPS
movieFPS = 10;

%1-D inverse FFT video image threshold
oneDinvFFTImThres = 0.02;

%Default frame number
frameNoImages_default = 97;

disp(['Device Settings Loaded.']);


end