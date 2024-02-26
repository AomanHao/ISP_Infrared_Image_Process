%% ��������
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------
%%
clear;
close all;
clc;

addpath('./algorithms/');

pathname = './data/test/';
img_conf = dir(pathname);
img_name = {img_conf.name};
img_num = numel({img_conf.name})-2;

data_type = 'bmp'; % raw: raw data
%bmp: bmp data
conf.savepath = './result/';
if ~exist(conf.savepath,'var')
    mkdir(conf.savepath)
end

methods = {'HE','PHE','DPHE','ADPHE'};
conf.remake=[];
for j = 1:numel(methods)
    enhan_type = methods{j};
    for i = 1:img_num
        switch data_type
            case 'bmp'
                name = split(img_name{i+2},'.');
                conf.imgname = name{1};
                conf.imgtype = name{2};
                img = imread([pathname,img_name{i+2}]);
                img_in = double(img);
                [m,n,z] = size(img_in);
%                 figure;imshow(img_in);
        end
        
        if z == 3
            img_yuv = rgb2ycbcr(img_in);
            img_in = uint8(img_yuv(:,:,1));
        else
        end
        
        %% Single channel data only
        switch enhan_type
            case 'HE'
                Iout=HE(img_in);
                
            case 'PHE'%ƽֱ̨��ͼ 
                conf.para = 0.001;
                Iout = PHE(img_in,img_in,conf);
                conf.remake = strcat('_para',num2str(conf.para));
                
                
            case 'DPHE'%˫��ֵƽֱ̨��ͼ
			%《 Infrared image enhancement through contrast enhancement by using multiscale new top-hat transform》
                conf.thr_Low =0.05;
                conf.thr_High =0.25;
                Iout = DPHE(img_in,img_in,conf);
                conf.remake = strcat('_para_',num2str(conf.thr_Low),'_',num2str(conf.thr_High));
                
            case 'ADPHE'%����Ӧ˫��ֵƽֱ̨��ͼ
			%《A new adaptive contrast enhancement algorithm for infrared images based on double plateaus histogram equalization》
                Iout = ADPHE(img_in,img_in,conf);
                
        end
        imwrite(uint8(Iout),strcat(conf.savepath,conf.imgname,'_',enhan_type,'_',conf.remake,'.png'));
    end
end
