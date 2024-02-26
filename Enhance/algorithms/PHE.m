function img_new=PHE(I,I_pre,conf)
% 平台直方图 限制统计像素数目

[height,width]=size(I_pre);
thr = height*width*conf.para;
p=zeros(1,256);
p_limit=zeros(1,256);
for i=1:height
    for j=1:width
        p(I_pre(i,j) + 1) = p(I_pre(i,j) + 1)  + 1;
    end
end

num =256;
%% 平台限制
p(p>thr) = thr;
p_limit = p;


s_sum=zeros(1,256);
s_sum(1)=p_limit(1);

for i=2:256
    s_sum(i)=p_limit(i) + s_sum(i-1);
end
sumpixel=sum(p_limit);
for i=1:256
    s_out(i) = s_sum(i)*num/sumpixel;
    if s_out(i) > 256
        s_out(i) = 256;
    end
end

%图像均衡化
I_equal = I;
for i=1:height
    for j=1:width
        I_equal(i,j) = s_out( I(i,j) + 1);
    end
end

img_new=I_equal;
img_new(img_new>255)=255;
img_new(img_new<0)=0;
% figure;imshow(uint8(img_new));
end

