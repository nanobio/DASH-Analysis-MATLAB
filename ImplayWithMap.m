function [handle] = ImplayWithMap(frames, limits, colormap, fps)
%%ImplayWithMap
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/260789
% Calls the implay function and adjust the color map
% Call it with 3 parameters:
% ImplayWithMap(frames, fps, limits)
% frames - 4D arrray of images
% fps - frame rate
% limits - an array of 2 elements, specifying the lower / upper
% of the liearly mapped colormap
% Returns a nadle to the player
%
% example: 
% h = ImplayWithMap(MyImageFrames, [10 50], 'gray', 10)


handle = implay(frames, fps);
handle.Visual.ColorMap.UserRangeMin = limits(1);
handle.Visual.ColorMap.UserRangeMax = limits(2);
handle.Visual.ColorMap.UserRange = 1;
handle.Visual.ColorMap.MapExpression = colormap;
