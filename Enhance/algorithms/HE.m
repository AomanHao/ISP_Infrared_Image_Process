%ordinary HE,copied from the Internet

function img_new=HE(I)

[height,width]=size(I);
p=zeros(1,256);

for i=1:height
    for j=1:width
        p(I(i,j) + 1) = p(I(i,j) + 1)  + 1;
    end
end

num =256;

s_sum=zeros(1,256);
s_sum(1)=p(1);

for i=2:256
    s_sum(i)=p(i) + s_sum(i-1);
end
sumpixel=sum(p);
for i=1:256
    s_out(i) = s_sum(i)*num/sumpixel;
    if s_out(i) > 256
        s_out(i) = 256;
    end
end


I_equal = I;
for i=1:height
    for j=1:width
        I_equal(i,j) = s_out( I(i,j) + 1);
    end
end

img_new=I_equal;
img_new(img_new>255)=255;
img_new(img_new<0)=0;
end

