function img_corr = DeSN_MeanCalcu(img_in,conf)
%% 均值计算消除条纹噪声

%figure;imshow(img_BPC);
img_in_m1 = mean(img_in,1);
img_in_mall = mean(img_in_m1,2);

img_in_m1_diff = img_in_m1 - img_in_mall;
 
img_corr = double(img_in) - repmat(img_in_m1_diff,size(img_in,1),1);

%figure;imshow(uint8(img_corr));