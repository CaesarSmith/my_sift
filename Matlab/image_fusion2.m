function image_fusion2(image_1,image_2,solution)

show_gif = 1;

if size(image_1, 3) == 3 base = rgb2gray(image_1); else base = image_1; end
if size(image_2, 3) == 3 rt = rgb2gray(image_2); else rt = image_2; end

[M, N] = size(base);
[m, n] = size(rt);

left_up = solution * [1, 1, 1]'; % 找到对实时图做变换之后的图像边界
left_down = solution * [1, m, 1]';
right_up = solution * [n, 1, 1]';
right_down = solution * [m, n, 1]';
X=[left_up(1)/left_up(3),left_down(1)/left_down(3),right_up(1)/right_up(3),right_down(1)/right_down(3)];
Y=[left_up(2)/left_up(3),left_down(2)/left_down(3),right_up(2)/right_up(3),right_down(2)/right_down(3)];
X_min = floor(min(X)); % 根据变换后图像的四个角的位置找到变换后图像的边界
X_max = ceil(max(X));
Y_min = floor(min(Y));
Y_max = ceil(max(Y));

match = zeros(max(Y_max, M) - min(Y_min, 1) + 1, max(X_max, N) - min(X_min, 1) + 1); % 考虑到变换后图像有可能超出基准图而设置的底层画布大小
% for i = 1:2
%     if i == 1 %% 只显示基准图
%         % 计算基准图在match中的位置, 
%         if (X_min < 1) lux = abs(X_min); else lux = 1; end; %# ok
%         if (Y_min < 1) luy = abs(Y_min); else luy = 1; end; %# ok
%         match(luy:luy+M-1, lux:lux+N-1) = base;
%         
%         img = (match - min(match(:))) / (max(match(:)) - min(match(:)));
%         [I, map] = gray2ind(img, 256);
%         imwrite(I, map, 'RegistrationResult.gif', 'gif', 'LoopCount', inf);
%     else %% 将实时图叠加在基准图上显示
        tform = maketform('projective', double(solution')); % 生成对应的变换矩阵
        f_1 = imtransform(rt, tform, 'XYScale', 1, 'XData', double([X_min, X_max]), 'YData', double([Y_min, Y_max]));
        [m_t, n_t] = size(f_1); % 实际上m_t = Y_max - Y_min + 1; n_t = X_max - X_min + 1;
        
        if(X_min < 1) lux = 1; else lux = X_min; end %# ok
        if(Y_min < 1) luy = 1; else luy = Y_min; end %# ok
        
        f_2 = match(luy : luy + m_t - 1, lux : lux + n_t - 1);
        same_index = find(f_1 & f_2);% Same region
        index_1 = find(f_1 & ~f_2);
        index_2 = find(~f_1 & f_2); %# ok
        f_2(same_index) = f_1(same_index);
        f_2(index_1) = f_1(index_1);
        match(luy : luy + m_t - 1, lux : lux + n_t - 1) = f_2;
        
%         img = (match - min(match(:))) / (max(match(:)) - min(match(:)));
%         [I, map] = gray2ind(img, 256);
%         imwrite(I, map, 'RegistrationResult.gif', 'gif', 'WriteMode', 'append');
%     end
% end

if show_gif
    global exist, exist = 1;
    h = figure('name', 'ShowMatch', 'numbertitle', 'off', 'DeleteFcn', 'global exist, exist = 0;', 'BusyAction','cancel');
    set(gcf, 'Position', [800, 50, 900, 900]);
    
    match = zeros(max(Y_max, M) - min(Y_min, 1) + 1, max(X_max, N) - min(X_min, 1) + 1); % 考虑到变换后图像有可能超出基准图而设置的底层画布大小
    t = 20;
    while exist && t >= 0
        if (X_min < 1) lux = abs(X_min); else lux = 1; end; %# ok
        if (Y_min < 1) luy = abs(Y_min); else luy = 1; end; %# ok
        match(luy:luy+M-1, lux:lux+N-1) = base;
        if exist
            figure(h);
            subplot('Position', [0.00, 0.00, 1.00, 1.00]); imshow(match, []);
        end
        pause(0.5);

        [m_t, n_t] = size(f_1); % 实际上m_t = Y_max - Y_min + 1; n_t = X_max - X_min + 1;
        
        if(X_min < 1) lux = 1; else lux = X_min; end %# ok
        if(Y_min < 1) luy = 1; else luy = Y_min; end %# ok
        
        f_2 = match(luy : luy + m_t - 1, lux : lux + n_t - 1);
        same_index = find(f_1 & f_2);% Same region
        index_1 = find(f_1 & ~f_2);
        index_2 = find(~f_1 & f_2); %# ok
        f_2(same_index) = f_1(same_index);
        f_2(index_1) = f_1(index_1);
        match(luy : luy + m_t - 1, lux : lux + n_t - 1) = f_2;
        if exist
            figure(h);
            subplot('Position', [0.00, 0.00, 1.00, 1.00]); imshow(match, []);
        end
        pause(0.5);
        
        t = t - 1;
    end
end
