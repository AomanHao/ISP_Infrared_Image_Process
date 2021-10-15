function out = DeSN_mhe(img, conf)
%% 	MHE
[rows,cols, channels] = size(img);

switch conf.noise_type
    case 'rowstripe'
        
    case 'colstripe'
        value_col_hist = get_col_hist(img,rows,cols);%统计每列的灰度频率
        frequ_accum_map = frequ_accum(value_col_hist,rows,cols);
        result_he = hist_equal(img,frequ_accum_map,rows,cols);
        figure;imshow(uint8(img));title('he灰度图');
        figure;imshow(uint8(result_he));title('he灰度图');
end






 

%% 函数区域 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function value_col_hist = get_col_hist(img,rows,cols)

value_col_hist = zeros(256,cols);
%% 统计每列的灰度评率
for j = 1:cols
    for i = 1:rows
        value_col_hist(img(i,j)+1,j) = value_col_hist(img(i,j)+1,j) + 1;
    end
end

function accumulation = frequ_accum(hist,rows,cols)
%% 频率累加
% 统计灰度值频率
frequency = hist/(rows*cols);
% 频率累加 frequency accumulation
accumulation = frequency;
for i = 2:256
    accumulation(1,i) = accumulation(1,i-1) + frequency(1,i);
end

function result = hist_equal(img_gray,frequ_accum,rows,cols)
%% 直方图均衡化
result = uint8(zeros(rows,cols));
frequ_accum_temp = floor(frequ_accum * 255);
for i=1:rows
    for j=1:cols
        result(i,j) = frequ_accum_temp(img_gray(i,j)+1);
    end
end
