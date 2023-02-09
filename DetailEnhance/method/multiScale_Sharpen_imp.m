function result = multiScale_Sharpen_imp( src, conf)
%%
Radius = conf.Radius;

sigma1 = 1.0;
sigma2 = 2.0;
sigma3 = 4.0;
H1 = fspecial('gaussian', [Radius,Radius], sigma1);
H2 = fspecial('gaussian', [Radius*2-1,Radius*2-1], sigma2);
H3 = fspecial('gaussian', [Radius*4-1,Radius*4-1], sigma3);
B1= imfilter(src, H1, 'replicate');
B2= imfilter(src, H2, 'replicate');
B3= imfilter(src, H3, 'replicate');
% figure;imshow(B3), title('B3');

D1=src-B1;
D2=B1-B2;
D3=B2-B3;
%%
beta = 3;
w1=0.75*beta;
w2=0.5*beta;
w3=0.25*beta;

switch conf.type 
    case 'single'
        result=w1.*D1+src;
    case 'multi'
        result=w1.*D1+w2*D2+w3*D3+src;
end
    

% figure;imshow(dest), title('dest');
end