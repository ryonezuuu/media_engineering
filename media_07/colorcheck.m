clear; close all; clc;
% 画像の引用元--------------------------------------------------------------
% img1 -> https://www.photock.jp/photo/big/photo0000-6368.jpg
% img3 -> https://www.istockphoto.com/jp/
% imgA -> https://photock.jp/detail/tenjin-fukuoka-city-10/
% imgB -> https://photock.jp/detail/sushi-3/

% ファイル読み込み ---------------------------------------------------------
% 学籍番号に応じて使う画像を変える（奇数:imgA, 偶数:imgB）
img = imread('imgA.jpg');%

[h, w, ch] = size(img);% 画像サイズを確認

hsvImg = rgb2hsv( img );% double型(0~1.0)
hue_mat = reshape(hsvImg(:,:,1), [1, h*w]);% Hueを１次元の配列に
sat_mat = reshape(hsvImg(:,:,2), [1, h*w]);% Saturationを１次元の配列に
val_mat = reshape(hsvImg(:,:,3), [1, h*w]);% Valueを１次元の配列に

iro_mihon = imread('hsv.bmp');% hsvの色見本画像

% 色の境界を決める ---------------------------------------------------------
hueBoarder  = [0.08, 0.13, 0.19, 0.48, 0.72, 0.82];

figure,
plot(1,1); hold on;% これがないと縦軸が反転しちゃう
image([0, 1], [1, 0], flipud(iro_mihon)); hold on; % flip upside-down
for i=1:length(hueBoarder)% 境界線の数だけループ
    xx = [hueBoarder(i), hueBoarder(i)];
    yy = [-0.1, 1.1];
    plot(xx, yy, 'k--');% 境界線を引く
end
xticks(0:0.05:1);
ylim([-0.25, 1.25]); xlim([-0.1, 1.1]); axis equal;
xlabel('Hue'); ylabel('Saturation'); title('どこに境界線を入れるか');

figure,
for i=1:8% Valueを８つの段階に分けてプロットする
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
    for j=1:length(hueBoarder)% 境界線の数だけループ
        xx = [hueBoarder(j), hueBoarder(j)];
        yy = [-0.1, 1.1];
        plot(xx, yy, '--', 'Color', [0.5, 0.5, 0.5]);% 境界線を引く
    end
    axis square; xlabel('Hue'); ylabel('Saturation');
    title(textStr);
end
%% 以下は触らない!
function img = checkImg(img)%
[h, w, ch] = size(img);
rng shuffle; id = randi(99999);
a = ['Media2024_tTrap_is_' num2str(id), '_' pwd];
% disp(a);
a = ( uint16( a ) );
a = dec2bin( a, 16 );
% disp(a);
for i=1:min([h, size(a,1)])
    tmp = a(i,:);
    for j=1:16
        d1 = dec2bin(img(i,j,2), 8);
        % disp(d1);
        d1(end) = tmp(j);
        img(i,j,2) = bin2dec( d1 );
    end
end
end