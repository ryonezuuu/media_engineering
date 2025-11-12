clear; close all; clc;
% 画像の読み込み------------------------------------------------------------
% img = imread('Bar_with_noise2.png');
img = imread('img_3.jpg');
[h, w, ch] = size(img);
% disp([h,w,ch]);
% 信号を用意 ---------------------------------------------------------------
r = double( img(:,:,1)/255 );% red　（値域[0, +1]に正規化）
g = double( img(:,:,2)/255 );% green
b = double( img(:,:,3)/255 );% blue

I = (r + g + b)/3;% Intensity（≒輝度）
I_thresh = I>0.1*max(max( I ));% Intensity の最大の 0.1倍以上の画素を抽出 

r = r .* I_thresh;% red を補正（輝度が極めて低いところの色差は知覚できないので）
g = g .* I_thresh;% green
b = b .* I_thresh;% blue

R = r - (g+b)/2;% R
G = g - (r+b)/2;% G
B = b - (r+g)/2;% B
Y = (r+g)/2 - abs(r-g)/2 - b;% Yellow

R = R .* double( R>0 );% R を補正（正の信号のみ残す）
G = G .* double( G>0 );% G 
B = B .* double( B>0 );% B 
Y = Y .* double( Y>0 );% Y
% ガウシアンフィルタを作る --------------------------------------------------
sig = 1;% 中心のσ []px
Range = -3*round(sig):3*round(sig);% フィルタの範囲
[x,y] = meshgrid(Range,Range);% フィルタ用の座標
gau = exp( -(x.^2 + y.^2)/(2*sig*sig) );% ガウシアンフィルタ
% figure, imagesc(gau); axis equal; colorbar; title('Gaussian filter')
% ガボールフィルタを作る ----------------------------------------------------
L = 2*sig;% 正弦波の波長 [px]
ori_list = [0, 45, 90, 135];% ガボールの方位 [°], Orientation list
for i=1:length( ori_list )
    ori = ori_list(i);
    newX = x*cos( pi*ori/180 ) - y*sin( pi*ori/180 );
    newY = x*sin( pi*ori/180 ) + y*cos( pi*ori/180 );
    gabo(i).filter = gau.*cos( 2*pi*newY/L );% ガボールフィルタ
end
% figure, imagesc(gabo(1).filter); axis equal; colorbar; title('Gabor filter')
%%
% 信号をマルチスケール化（ガウシアン＆ガボールピラミッド） ----------------------
figure,
subplot(3, 3, 1); imagesc(I); axis equal; colormap('gray'); title('Original (Intensity)');
for i=1:8% ぼかして，画像サイズを半分にする
    if i==1% 1回目はそのまま
        tmpI = filter2(gau, I, 'same');% ガウシアンフィルタでぼかす
        tmpR = filter2(gau, R, 'same');%
        tmpG = filter2(gau, G, 'same');%
        tmpB = filter2(gau, B, 'same');%
        tmpY = filter2(gau, Y, 'same');%
        for ori_num=1:length( ori_list )% 方位(Orientation)の数だけループ
            tmpOri(ori_num).img = I;
        end
    else% 2回目からは１つ前のスケールの画像を
        tmpI = filter2(gau, multi_I(i-1).img, 'same');% ガウシアンフィルタ でぼかす
        tmpR = filter2(gau, multi_R(i-1).img, 'same');
        tmpG = filter2(gau, multi_G(i-1).img, 'same');
        tmpB = filter2(gau, multi_B(i-1).img, 'same');
        tmpY = filter2(gau, multi_Y(i-1).img, 'same');
        for ori_num=1:length( ori_list )% 方位(Orientation)の数だけループ
            tmpOri(ori_num).img = filter2(gabo(ori_num).filter, tmpOri(ori_num).img, 'same');% ガボールフィルタ
        end
    end
    multi_I(i).img = imresize( tmpI, 0.5);% Intensity （画像サイズを半分に）
    multi_R(i).img = imresize( tmpR, 0.5);%
    multi_G(i).img = imresize( tmpG, 0.5);%
    multi_B(i).img = imresize( tmpB, 0.5);%
    multi_Y(i).img = imresize( tmpY, 0.5);%
    for ori_num=1:length( ori_list )% 方位の数だけループ
        multi_Ori(i,ori_num).img = imresize( tmpOri(ori_num).img, 0.5);
    end
    subplot(3, 3, i+1); imagesc(multi_I(i).img); axis equal; colormap('gray');
    title(['Gaussian Pyramid, Scale = ' num2str(i)]); 
end
%%
% 中心周辺の差分 --------------------------------------------------
c_list = [2,3,4];% 中心ガウシアンのσ [px], Center
% c_list = [1,2,3];% 中心ガウシアンのσ [px], Center
delta_list = [3,4];% 中心と周辺のガウシアンのσの差分 [px]
% delta_list = [1,2];% 中心と周辺のガウシアンのσの差分 [px]

figure,
for i = 1:length(c_list)% 中心(Center)ガウシアンの分だけループ
    for j = 1:length(delta_list)% 周辺(Surround)ガウシアンの分だけループ
        c = c_list(i);% 中心の画像スケール, Center
        s = c + delta_list(j);% 周辺の画像スケール, Surround
        % Center ----------------------------------------------------------
        I_c = multi_I(c).img;% Intensity
        R_c = multi_R(c).img;% Red
        G_c = multi_G(c).img;% Green
        B_c = multi_B(c).img;% Blue
        Y_c = multi_Y(c).img;% Yellow
        for ori_num=1:length( ori_list )% 方位の数だけループ
            Ori_c(ori_num).res = multi_Ori(c,ori_num).img;% Orientation
        end
  
        % 元画像サイズまで戻す（各サイズで比較するため）
        I_c = imresize( I_c, [h, w]);
        R_c = imresize( R_c, [h, w]);
        G_c = imresize( G_c, [h, w]);
        B_c = imresize( B_c, [h, w]);
        Y_c = imresize( Y_c, [h, w]);
        for ori_num=1:length( ori_list )% 方位の数だけループ
            Ori_c(ori_num).res = imresize(Ori_c(ori_num).res, [h, w]);
        end
        % Surround --------------------------------------------------------
        I_s = multi_I(s).img;% Intensity
        R_s = multi_R(s).img;% Red
        G_s = multi_G(s).img;% Green
        B_s = multi_B(s).img;% Blue
        Y_s = multi_Y(s).img;% Yellow
        for ori_num=1:length( ori_list )% 方位の数だけループ
            Ori_s(ori_num).res = multi_Ori(s,ori_num).img;% Orientation
        end
        
        % 元画像サイズまで戻す（各サイズで比較するため）
        I_s = imresize( I_s, [h, w]);
        R_s = imresize( R_s, [h, w]);
        G_s = imresize( G_s, [h, w]);
        B_s = imresize( B_s, [h, w]);
        Y_s = imresize( Y_s, [h, w]);
        for ori_num=1:length( ori_list )% 方位の数だけループ
            Ori_s(ori_num).res = imresize( Ori_s(ori_num).res, [h, w]);
        end
        
        % Center Surround difference --------------------------------------
        I_cs(i,j).diff = abs( I_c - I_s );% 中心と周辺の差分
        RG_cs(i,j).diff = abs( (R_c - G_c)- (G_s - R_s) );% 中心と周辺の差分
        BY_cs(i,j).diff = abs( (B_c - Y_c)- (Y_s - B_s) );% 中心と周辺の差分
        for ori_num=1:length( ori_list )% 方位の数だけループ
            ori_cs(i,j,ori_num).diff = abs( Ori_c(ori_num).res - Ori_s(ori_num).res );% 中心と周辺の差分
        end
        
        graph_pos = (i-1)*length(delta_list) + mod(j-1,length(delta_list))+1;% subplot内での位置
        
        figure(1001);% Intensity の DoG
        subplot(length(c_list),length(delta_list),graph_pos);
        imagesc( I_cs(i,j).diff ); axis equal; colormap('gray'); colorbar;
        title(['I_c - I_s (c=' num2str(c) ',s=' num2str(s) ')']);
        
        figure(1002);% RedGreen の DoG
        subplot(length(c_list),length(delta_list),graph_pos);
        imagesc( RG_cs(i,j).diff ); axis equal; colormap('gray'); colorbar;
        title(['RG_c - RG_s (c=' num2str(c) ',s=' num2str(s) ')']);
        
        figure(1003);% BlueYellow の DoG
        subplot(length(c_list),length(delta_list),graph_pos);
        imagesc( BY_cs(i,j).diff ); axis equal; colormap('gray'); colorbar;
        title(['BY_c - BY_s (c=' num2str(c) ',s=' num2str(s) ')']);
        
        for ori_num=1:length( ori_list )% 方位の数だけループ
            figure(1100+ori_num);% Orientation の Gabor
            subplot(length(c_list),length(delta_list),graph_pos);
            imagesc( ori_cs(i,j,ori_num).diff ); axis equal; colormap('gray'); colorbar;
            title([num2str(ori_list(ori_num)) ' Ori_c - Ori_s (c=' num2str(c) ',s=' num2str(s) ')']);
        end
    end
end
%%
% 各特徴内でマップを重ねる -----------------------------------------------------------
I_sumMap = zeros(h,w);
C_sumMap = zeros(h,w);
Ori_each_sumMap = zeros( h, w, length(ori_list) );
for i = 1:length(c_list)% 中心(Center)ガウシアンの分だけループ
    for j = 1:length(delta_list)% 周辺(Surround)ガウシアンの分だけループ
        c = c_list(i);% 中心の画像スケール
        s = c + delta_list(j);% 周辺の画像スケール
        
        norm_I_cs(i,j).diff = myImNorm( I_cs(i,j).diff );% マップ内で正規化
        norm_RG_cs(i,j).diff = myImNorm( RG_cs(i,j).diff );
        norm_BY_cs(i,j).diff = myImNorm( BY_cs(i,j).diff );
        for ori_num=1:length( ori_list )% 方位の数だけループ
            norm_ori_cs(i,j,ori_num).diff = myImNorm( ori_cs(i,j,ori_num).diff );
        end
        
        I_sumMap = I_sumMap + norm_I_cs(i,j).diff;
        C_sumMap = C_sumMap + norm_RG_cs(i,j).diff + norm_BY_cs(i,j).diff;
        for ori_num=1:length( ori_list )% 方位の数だけループ
            Ori_each_sumMap(:,:,ori_num) = Ori_each_sumMap(:,:,ori_num) + norm_ori_cs(i,j,ori_num).diff;
        end
        
        graph_pos = (i-1)*length(delta_list) + mod(j-1,length(delta_list))+1;% subplot内での位置
        
        figure(2004);% 正規化した Intensity の DoG
        subplot(length(c_list),length(delta_list),graph_pos);
        imagesc( norm_I_cs(i,j).diff ); caxis([0, 1]); axis equal; colormap('gray'); colorbar;
        title(['Normalized I_c - I_s (c=' num2str(c) ',s=' num2str(s) ')']);
        
        figure(2005);% 正規化した RedGreen の DoG
        subplot(length(c_list),length(delta_list),graph_pos);
        imagesc( norm_RG_cs(i,j).diff ); axis equal; colormap('gray'); colorbar;
        title(['Normalized RG_c - RG_s (c=' num2str(c) ',s=' num2str(s) ')']);
        
        figure(2006);% 正規化した BlueYellow の DoG
        subplot(length(c_list),length(delta_list),graph_pos);
        imagesc( norm_BY_cs(i,j).diff ); axis equal; colormap('gray'); colorbar;
        title(['Normalized BY_c - BY_s (c=' num2str(c) ',s=' num2str(s) ')']);
        
        for ori_num=1:length( ori_list )% 方位の数だけループ
            figure(2120+ori_num);% 正規化したOrientation の Gabor
            subplot(length(c_list),length(delta_list),graph_pos);
            imagesc( norm_ori_cs(i,j,ori_num).diff ); axis equal; colormap('gray'); colorbar;
            title([num2str(ori_list(ori_num)) 'Normalized Ori_c - Ori_s (c=' num2str(c) ',s=' num2str(s) ')']);
        end
    end
end

Ori_sumMap = zeros(h,w);
for ori_num=1:length( ori_list )
    Ori_sumMap = Ori_sumMap + myImNorm( Ori_each_sumMap(:,:,ori_num) );
end
Ori_sumMap = Ori_sumMap / length(ori_list); % 平均化

% Ori_sumMap = max(Ori_each_sumMap, [], 3);  % 方向ごとの最大値を抽出
Ori_sumMap = myImNorm(Ori_sumMap);         % 最終的に正規化


% 全特徴を重ねる -----------------------------------------------------------
Saliency_map = zeros(h,w);
Saliency_map = Saliency_map + myImNorm( I_sumMap );% マップ内で正規化
Saliency_map = Saliency_map + myImNorm( C_sumMap );% マップ内で正規化
Saliency_map = Saliency_map + myImNorm( Ori_sumMap );% マップ内で正規化
Saliency_map = Saliency_map / 3;

figure(7);% 各特徴マップ
subplot(2,3,1);
imagesc( C_sumMap ); axis equal; colormap('gray'); colorbar;
title(['Color feature']);

subplot(2,3,2);
imagesc( I_sumMap ); axis equal; colormap('gray'); colorbar;
title(['Intensity feature']);

subplot(2,3,3);
imagesc( Ori_sumMap ); axis equal; colormap('gray'); colorbar;
title(['Orientation feature']);

subplot(2,3,5);
imagesc( Saliency_map ); axis equal; colormap('gray'); colorbar;
title(['Saliency Map']);

subplot(2,3,4);
imagesc( img ); axis equal; colorbar;
title(['Original']);
% % saveas(gcf, '20XX531XYZ','png');% 図に名前を付けて保存
%%
function output = myImNorm(input)
    input = double(input);
    input = (input - min(input(:))) / (max(input(:)) - min(input(:)));
    
    
    isMax = imregionalmax(input);
    localMax = input(isMax & input < 1);
    
    if ~isempty(localMax)
        meanLocalMax = mean(localMax);
        output = input * (1 - meanLocalMax)^2;
    else
        output = ones(size(input));
    end
end
%%
% function output = myImNorm(input)
%     input = double(input);
%     input = (input - min(input(:))) / (max(input(:)) - min(input(:)));
%     
%     
%     % isMax = (input == ordfilt2(input, 9, true(3)));% 近傍最大の検出（3x3）
%     isMax = (input == ordfilt2(input, 49, true(7)));% 近傍最大の検出（7x7）
%     localMax = input(isMax & input < 1);  % 最大値そのものは除外可
%     
%     if ~isempty(localMax)
%         meanLocalMax = mean(localMax);
%         output = input * (1 - meanLocalMax)^2;
%     else
%         output = ones(size(input));
%     end
% end
%%
% function output = myImNorm( input )% 古いバージョン
% [h,w] = size(input);
% input_max = max(max( input ));
% input_min = min(min( input ));
% if input_max == input_min
%     output = ones(size(input) );
% else
%     diff = input_max - input_min;
%     nInput = (input-input_min)/diff;% 正規化
%     
%     y_diff = nInput(2:end,2:end) - nInput(1:end-1,2:end);% 1回差分
%     x_diff = nInput(2:end,2:end) - nInput(2:end,1:end-1);
%     
%     y_diff2 = y_diff(2:end,2:end) - y_diff(1:end-1,2:end);% 2回差分
%     x_diff2 = x_diff(2:end,2:end) - x_diff(2:end,1:end-1);
%     
%     sabun = (abs(y_diff)>0.01) & (abs(x_diff)>0.01);
%     kyokudai = (y_diff2<0) & (x_diff2<0);% 上に凸
%     saidai = max(max( nInput ));% マップ内最大値
%     
%     useSabun = sabun( 1:h-2, 1:w-2);
%     useInput = nInput < saidai;% マップ内は対象外 
%     useInput = useInput(1:h-2, 1:w-2);% 差分画像に配列サイズを合わせる
% 
%     localMax_Num = sum( sum( double( useSabun.*kyokudai.*useInput ) ) );
%     localMax = nInput(1:h-2,1:w-2) .* double( useSabun.*kyokudai );
%     if localMax_Num > 0
%         meanLocalMax = sum(sum(localMax)) / localMax_Num;
%         output = nInput .* ((saidai - meanLocalMax)^2);
%     else
%         output = ones(size(input) );
%     end
% end
% end
