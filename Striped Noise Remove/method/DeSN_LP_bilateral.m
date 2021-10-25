function img_out = DeSN_LP_bilateral(img,conf)
%% Ë«±ßÂË²¨·ÖÀëÌõÎÆÔëÉù
w = conf.w;
sigma = conf.sigma;
img_lp = bfilter2(img,w,sigma);
img_hp = img - img_lp;
figure;imshow(img_lp);
figure;imshow(img_hp);
