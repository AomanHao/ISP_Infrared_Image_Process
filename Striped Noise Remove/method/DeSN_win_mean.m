function img_out = DeSN_win_mean(img,conf)

%%  param
fliter_pre_mode = '';%mid
fliter_mode = 'mean';%mean,gaussW
fliter2_mode = 'mid';%mid,
m = conf.m_img;
n = conf.n_img;
win_radius  = conf.win_radius;
win_size = 2*conf.win_radius+1;
mid_size = floor(win_size^2/2)+1;
img_out = img;
thr = win_radius+1;
sigma = conf.sigma;
img_out = img;
%%
for  i1 = 1 +win_radius: m - win_radius
    for j1 =  1+ win_radius:n - win_radius
        
        
        img_temp = img(i1-win_radius:i1+win_radius,j1-win_radius:j1+win_radius);
        center_pixel = img(i1,j1);
        %% 预处理
        switch fliter_pre_mode
            case 'mid'
                if center_pixel == 0 || center_pixel == 255
                    img_temp_line = sort(img_temp(:));
                    img_temp(win_radius+1,win_radius+1) = img_temp_line(mid_size);
                end
        end
        %% 横条纹处理
        
        a = img_temp(win_radius+1,:)-center_pixel;
        a1 = numel(find(a==0))-1;
        b = img_temp(:,win_radius+1)-center_pixel;
        b1 = numel(find(b==0))-1;
        
        if (a1+b1) >= thr
            switch fliter_mode
                case 'mean'
                    img_out(i1,j1) = mean(mean(img_temp));
                case 'gaussW'
                    w= fspecial('gaussian',[win_size,win_size],sigma);
                    img_out(i1,j1) =  sum(img_temp.*w,'all')/sum(w,'all');
            end
        else
            switch fliter2_mode
                case 'mid'
                    if center_pixel == 0 || center_pixel == 255
                        img_temp_line = sort(img_temp(:));
                        img_out(i1,j1) = img_temp_line(mid_size);
                    end
            end
        end
    end
end
% figure;imshow(uint8(img));
imwrite((img_out),[conf.save_file,conf.imgname,'_Pre_',fliter_pre_mode,'_Fliter_',fliter_mode,'_F2_',fliter2_mode,'_win',num2str(win_size),'_thr',num2str(thr),'.bmp']);
% figure;imshow(uint8(img_out));