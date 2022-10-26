
%% AGC test
clear;
clc;
close all;

conf.row=512;
conf.col=640;

conf.Thr=15;%优化直方图算法级别
conf.bit=16;%数据为14比特

load('data.mat');

data_8 = bitshift(data,-8);
figure;imshow(data_8);title('原始图像高8位')

data_out=Hist_AGC(data,conf);%优化直方图均衡化算法
figure;imshow(uint8(data_out));title('均衡化图像')
