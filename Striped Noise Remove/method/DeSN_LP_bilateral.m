function img_out = DeSN_LP_bilateral(img,conf)
%% Ë«±ßÂË²¨·ÖÀëÌõÎÆÔëÉù

img = img;
conf = conf;
w     = 2;       % bilateral filter half-width
sigma = [3 0.1]; % bilateral filter standard deviations
img_lp = bfilter2(img,w,sigma);
img_hp = img - img_lp;
figure;imshow(img_lp);
figure;imshow(img_hp);



Gfactor = conf.Gfactor;
Lfactor = conf.Lfactor;

f = conv2(img, Gfactor, 'same');
f2 = conv2(img, Lfactor', 'same');
figure;imshow(uint8(abs(f)));
figure;imshow(abs(f2));