%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------

%% AGC test
clear;
clc;
close all;

conf.row=512;
conf.col=640;

conf.Thr=15;%�Ż�ֱ��ͼ�㷨����
conf.bit=16;%����Ϊ14����

load('data.mat');

data_8 = bitshift(data,-8);
figure;imshow(data_8);title('ԭʼͼ���8λ')

data_out=Hist_AGC(data,conf);%�Ż�ֱ��ͼ���⻯�㷨
figure;imshow(uint8(data_out));title('���⻯ͼ��')
