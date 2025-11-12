clear; close all; clc;
% img = imread('img1.jpg');% jpegとjpgが混在していて紛らわしいですね
% img = imread('img2.jpeg');
img = imread('img3.jpg');
[h, w, ch] = size(img);

figure,
imshow(img);

% 色をRGBで確認 ------------------------------------------------------------
r = img(:,:,1); r_mat = reshape(r, [1, h*w]);% 赤チャンネルを１次元配列に変形
g = img(:,:,2); g_mat = reshape(g, [1, h*w]);% 緑チャンネルを１次元配列に変形
b = img(:,:,3); b_mat = reshape(b, [1, h*w]);% 青チャンネルを１次元配列に変形

figure, 
subplot(3,2,1);
histogram(r_mat, 'faceColor', 'r'); xlabel('Rの階調値'); ylabel('頻度');
subplot(3,2,2);
tmpImg = img; tmpImg(:,:,2:3)=0;% 赤だけ画像をつくる
imagesc(tmpImg); axis equal;

subplot(3,2,3);
histogram(g_mat, 'faceColor', 'g'); xlabel('Gの階調値'); ylabel('頻度');
subplot(3,2,4);
tmpImg = img; tmpImg(:,:,[1,3])=0;% 緑だけ画像をつくる
imagesc(tmpImg); axis equal;

subplot(3,2,5);
histogram(b_mat, 'faceColor', 'b'); xlabel('Bの階調値'); ylabel('頻度');
subplot(3,2,6);
tmpImg = img; tmpImg(:,:,1:2)=0;% 青だけ画像をつくる
imagesc(tmpImg); axis equal;

% 色をHSVで確認 -----------------------------------------------------------------
hsvImg = rgb2hsv(img);
hue = hsvImg(:,:,1); hue_mat = reshape(hue, [1, h*w]);% Hue を１次元配列に変形
sat = hsvImg(:,:,2); sat_mat = reshape(sat, [1, h*w]);% Saturation を１次元配列に変形
val = hsvImg(:,:,3); val_mat = reshape(val, [1, h*w]);% Value を１次元配列に変形

figure, 
subplot(3,2,1);
histogram(hue_mat, 'faceColor', 'black'); xlabel('Hue'); ylabel('頻度');
subplot(3,2,2);
imagesc(hue); axis equal; colormap('gray'); colorbar; title('Hue map');

subplot(3,2,3);
histogram(sat_mat, 'faceColor', 'black'); xlabel('Saturation'); ylabel('頻度');
subplot(3,2,4);
imagesc(sat); axis equal; colormap('gray'); colorbar; title('Saturation map');

subplot(3,2,5);
histogram(val_mat, 'faceColor', 'black'); xlabel('Value'); ylabel('頻度');
subplot(3,2,6);
imagesc(val); axis equal; colormap('gray'); colorbar; title('Value map');

figure,
subplot(1,2,1);
histogram2(hue_mat, sat_mat); xlabel('Hue'); ylabel('Saturation'); zlabel('頻度');
subplot(1,2,2);
histogram2(hue_mat, val_mat); xlabel('Hue'); ylabel('val'); zlabel('頻度');

% 色をHSVの散布図で確認 -----------------------------------------------------------------
% figure,
% scatter3(hue_mat, sat_mat, val_mat, 'k.');
% xlabel('Hue'); ylabel('Saturation'); zlabel('Value');

% figure,
% for i=1:700:length(hue_mat)% 全画素を探索すると時間がかかるので700とばしで
%     scatter3(hue_mat(i), sat_mat(i), val_mat(i), '.', 'MarkerEdgeColor', ...
%         hsv2rgb([hue_mat(i), sat_mat(i), val_mat(i)])); hold on;
% end
% xlabel('Hue'); ylabel('Saturation'); zlabel('Value');

figure,
plot(hue_mat, sat_mat, 'k.', 'MarkerSize', 1); hold on;
axis square; xlabel('Hue'); ylabel('Saturation');
title('すべての画素で');

figure,
for i=1:8
    underLimit = (i-1)/8;% Valueの下限
    upperLimit = i/8;% Valueの上限
    if i<8
        val_idx = find( val_mat>=underLimit & val_mat<upperLimit );% 条件に合致するインデックス
        textStr = [ num2str(underLimit) ' <= V < ' num2str(upperLimit)];
    elseif i==8% 最後は上限なし(1を含める)
        val_idx = find( val_mat>=underLimit);
        textStr = [ num2str(underLimit) ' <= V'];
    end
    subplot(3,3,i);
    plot(hue_mat(val_idx), sat_mat(val_idx), 'k.', 'MarkerSize', 1); hold on;
    axis square; xlabel('Hue'); ylabel('Saturation');
    title(textStr);
end