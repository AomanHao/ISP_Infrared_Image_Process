%% 
% ¸öÈË²©¿Í www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
% Zhihu https://www.zhihu.com/people/aomanhao-hao
%--------------------------------------
%% Detail Enhancement Test Code
clear;
close all;
clc;

addpath('./method');
addpath('./tools');

pathname = './data2/';
img_conf = dir(pathname);
img_name = {img_conf.name};
img_num = numel({img_conf.name})-2;

data_type = 'bmp'; %bmp: bmp data
conf.savepath = './result/';
if ~exist(conf.savepath,'var')
    mkdir(conf.savepath)
end

method = 'multiScale_paper';%multiScale_paper\multiScale_imp\Super_Sharpen
conf.remake=[];
for i = 1:img_num
    switch data_type
        case 'bmp'
            name = split(img_name{i+2},'.');
            conf.imgname = name{1};
            conf.imgtype = name{2};
            img = imread([pathname,img_name{i+2}]);
            img_in = im2double(img);
            [m_img,n_img,z_img] = size(img_in);
            figure;imshow(img_in);
    end
    
    if z_img == 3
        img_yuv = rgb2ycbcr(img_in);
        img_y = img_yuv(:,:,1);
    else
        img_y = img_in;
    end
    
    %% Single channel data only
    switch method
        case 'multiScale_paper'
            %¡¶Dark image enhancement based onpairwise target contrast and multi-scale detail boosting¡·
            Radius = 5;
            d_out = multiScale_paper( img_y, Radius);
        case 'multiScale_imp'
            % multiScale Sharpen Improved algorithm
            conf.Radius = 5;
            conf.type = 'single';% 'single\multi_weak_weight\multi_mid_weight\multi_high_weight
            d_out = multiScale_Sharpen_imp( img_y, conf);
            
        case 'Super_Sharpen'
            %super sharpen by aomanhao
            conf.w = 0.8;
            d_out = super_sharpness_aomanhao(img_y,conf);
            
    end
    
%     figure;imshow(d_out);
    imwrite(d_out,[conf.savepath,conf.imgname,method,'.png'])
end
