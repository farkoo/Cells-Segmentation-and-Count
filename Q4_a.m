clc; clear; close all;

I = imread('Cells.tif');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using the multithresh function, we segment the image % 
% and use 3 thresholds for this.                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
level = multithresh(I, 3);
seg = imquantize(I, level);
seg(seg > 1) = 3;
seg(seg == 1) = 0;
seg(seg == 3) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some cells are very close to each other                    %
% and are connected to each other after segmentation,        %
%                                                            %
% In order to calculate the number of cells correctly,       %
% we reduce the boundary of objects using the erosion method %
% to separate these cells.                                   %
%                                                            %
% As a result, some cells, only a small part of which were   %
% in the margin of the image, are removed.                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SE1 = strel('square',12);
IM1 = imerode(seg, SE1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% My blabel function that The bw function has only one input argument, %
% which is an image whose pixel values are zero or one                 %
%                                                                      %
% This function returns the output of a number,                        %
% which is the number of cells,                                        %
% as well as an image in which the cells are labeled                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[count,im] = MY_bwlabel(IM1);

% Show each conected component colorful
coloredLabels = label2rgb(im, 'hsv', 'k', 'shuffle');

imshow(coloredLabels, [])
count

