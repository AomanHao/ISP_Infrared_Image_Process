%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------
%% 细节增强测试
clear;
close all;
clc;

addpath('./method');
addpath('./tools');

pathname = './data/';
img_conf = dir(pathname);
img_name = {img_conf.name};
img_num = numel({img_conf.name})-2;

data_type = 'bmp'; % raw: raw data
                    %bmp: bmp data
conf.savepath = './result/';
if ~exist(conf.savepath,'var')
    mkdir(conf.savepath)
end

conf.remake=[];
for i = 1:img_num
    switch data_type
        case 'bmp'
            name = split(img_name{i+2},'.');
            conf.imgname = name{1};
            conf.imgtype = name{2};
            img_re = imread([pathname,img_name{i+2}]);
            img = im2double(img_re);
            [m_img,n_img,z_img] = size(img);
            figure;imshow(img);
    end

    %% enhance
    
    
    
    %% result save
    imwrite(uint8(enhan_img),strcat(conf.savepath,conf.name,'_',enhan_type,'-',num2str(t),'_',conf.remake,'.png'));
    
end





