%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
%--------------------------------------

close all;
clear;
clc;
%% variable
dp_slope = 0.02;
dp_thresh = -0.3;
r=3;        %Stencil radius

%% read raw image
% x = 0:255;
% y = dp_slope * x + dp_thresh;
% y(y<0) = 0;
% y(y>1) = 1;
% figure,
% plot(0:255,y)
% axis([0 255 0 1.5])

[filename, pathname] = ...
    uigetfile({'*.raw'}, 'select picture');
str = [pathname filename];
fp = fopen(str, 'rb');
[X,l] = fread(fp, [1920,1080], 'uint16');
fclose(fp);
img = uint8(X/16)';
[height, width] = size(img);
img_correct = zeros(height, width);

%% Image edge extension
imgn=zeros(height+2*r,width+2*r);
imgn(r+1:height+r,r+1:width+r)=img;
imgn(1:r,r+1:width+r)=img(1:r,1:width);                 
imgn(1:height+r,width+r+1:width+2*r+1)=imgn(1:height+r,width:width+r);    
imgn(height+r+1:height+2*r+1,r+1:width+2*r+1)=imgn(height:height+r,r+1:width+2*r+1);    
imgn(1:height+2*r+1,1:r)=imgn(1:height+2*r+1,r+1:2*r);

%% dp algorithm
for i = r+1:height-r
    for j = r+1:width-r

        img_r = imgn(i-r:2:i+r, j-r:2:j+r);
        data_r_center = img_r(r, r);
        data_r_diff(1:r+1, 1:r+1) = abs(img_r - img_r(r,r));
        data_r_sort = sort(img_r(:));
        data_r_median = data_r_sort(r*2+1);
        data_r_detect = data_r_diff * dp_slope + dp_thresh;
        data_r_detect(data_r_detect < 0) = 0;
        data_r_detect(data_r_detect > 1) = 1;
        data_r_judge = sum(sum(data_r_detect > 0));
        data_r_weight = sum(sum(data_r_detect)) / data_r_judge;
        if i-r == 18 && j-r == 43
            a = 1;
        end
        if data_r_judge >= 7
            data_r_correct = data_r_median * data_r_weight + (1-data_r_weight) * data_r_center;
        else
            data_r_correct = data_r_center;
        end
        img_correct(i-r, j-r) = data_r_correct;

    end
end

%% show
figure,imshow(uint8(img));
figure,imshow(uint8(img_correct));
