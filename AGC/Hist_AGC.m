function img_out=Hist_AGC(img,conf)
%% 基于灰度直方统计的线性拉伸
img_out=zeros(conf.row,conf.col);
n_len=2^conf.bit;
Thr = conf.Thr;
n=zeros(1,n_len);
distance1=4;
distance2=50;
for i=1:conf.row            
    for j=1:conf.col
        if img(i,j)<0
            img(i,j)=abs(img(i,j));
        end
        n(img(i,j)+1)=n(img(i,j)+1)+1;
    end
end
%--------------------------------%%
x=zeros(1,n_len);
k=0;
for i=1:n_len
    if n(i)>Thr
        k=i;
        x(i)=1;
        break;
    end
end
j=k;

for i=k+1:n_len
    if n(i)>Thr
       if i-j<distance1
            x(i)=x(i-1)+1;
        elseif (i-j)>=distance1 && (i-j)<=distance2
            x(i)=x(i-1)+1;
        else 
            x(i)=x(i-1)+1;
        end
        j=i;
    else
        x(i)=x(i-1);
    end
end

T=uint8(255*x/x(n_len));
for i=1:conf.row
    for j=1:conf.col
        img_out(i,j)=T(img(i,j)+1);
    end
end