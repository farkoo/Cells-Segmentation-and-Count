clc; clear; close all;

I = imread('Cells.tif');

level = multithresh(I, 3);
seg = imquantize(I, level);
seg(seg > 1) = 3;
seg(seg == 1) = 0;
seg(seg == 3) = 1;

SE1 = strel('square',12);
IM1 = imerode(seg, SE1);

[count, im] = MY_bwlabel(IM1);

hist_ = MY_histogram(uint8(im));

excel = zeros(count, 2);
counter = 1;
im = uint8(im);
for val = 1 :255
    num = hist_(val+1);
    if num ~= 0
        mask = uint8(zeros(size(im)));
        mask(im == val) = 1;
        summation = sum(mask(:));
        avg = sum(sum(mask.*I))/num;
        excel(counter, 1) = summation;
        excel(counter, 2) = avg;
        counter = counter + 1;
    end
end

xlswrite('Result.xlsx', excel);