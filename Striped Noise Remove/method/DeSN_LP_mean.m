function img_out = DeSN_LP_mean(img,conf)
%% 均值滤波分离条纹噪声

img = img;
conf = conf;
win = conf.winfactor*2+1;
% value = mean(img,'all');
% img_hp = img - value;

%% 
filter = fspecial('average',[win,win]);
img_lp = imfilter(img,filter);
img_hp = img - img_lp;


figure;imshow(img_lp);
figure;imshow(img_hp);
