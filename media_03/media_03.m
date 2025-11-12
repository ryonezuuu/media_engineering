clear; close all; clc;

% 画像の読み込み -----------------------------------------------------------
% img = imread('Lenna.jpg');
img = imread('test2.jpg');
% grayImg = rgb2gray(img);% 使えるライセンス数50までなので，以下で代用
grayImg = uint8( (0.299*double(img(:,:,1)) + 0.5877*double(img(:,:,2)) + 0.114*double(img(:,:,3)) ) );
[h, w] = size(grayImg);

%% 画像の表示 -----------------------------------------------------------
figure,
subplot(2,4,1); image(img); axis equal; title('オリジナル');
subplot(2,4,2); imagesc(grayImg); axis equal; colormap('gray'); title('グレイスケール');
%% 

% ぼかしフィルタ -----------------------------------------------------------
LowPassFilter = [1, 1, 1; 1, 2, 1; 1, 1, 1]/10;
blurImg = zeros(h,w);
for i=2:h-1% 画像の行方向ループ
    for j=2:w-1% 画像の列方向ループ
        tmp = 0;
        for m=-1:1% フィルタの縦方向ループ
            for n=-1:1% フィルタの横方向ループ
                tmp = tmp + double( grayImg(i+m,j+n)*LowPassFilter(m+2,n+2) );% ←ここを修正する
            end
        end
        blurImg(i,j) = tmp;
    end
end
subplot(2,4,5); imagesc(blurImg); axis equal; colormap('gray'); title('ぼかしフィルタ');

%% エッジ検出フィルタ(転置前) -----------------------------------------------------------
HighPassFilter = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
vImg = zeros(h,w);
for i=2:h-1% 画像の行方向ループ
    for j=2:w-1% 画像の列方向ループ
        tmp = 0;
        for m=-1:1% フィルタの縦方向ループ
            for n=-1:1% フィルタの横方向ループ
                tmp = tmp + double(grayImg(i+m,j+n))*HighPassFilter(m+2,n+2); % ←ここを修正する
            end
        end
        vImg(i,j) = tmp;
    end
end
subplot(2,4,6); imagesc(vImg); axis equal; colormap('gray'); title('エッジ検出フィルタ(転置前)');

%% エッジ検出フィルタ(転置後) -----------------------------------------------------------
tHighPassFilter = HighPassFilter';
hImg = zeros(h,w);
for i=2:h-1% 画像の行方向ループ
    for j=2:w-1% 画像の列方向ループ
        tmp = 0;
        for m=-1:1% フィルタの縦方向ループ
            for n=-1:1% フィルタの横方向ループ
                tmp = tmp + double(grayImg(i+m,j+n))*tHighPassFilter(m+2,n+2);% ←ここを修正する
            end
        end
        hImg(i,j) = tmp;
    end
end
subplot(2,4,7); imagesc(hImg); axis equal; colormap('gray'); title('エッジ検出フィルタ(転置後)');

%% エッジの強さを計算 -----------------------------------------------------------
intensityImg = zeros(h,w);
for i=1:h% 画像の行方向ループ，これはフィルタリングじゃないので，はみ出しは気にしない
    for j=1:w% 画像の列方向ループ
        intensityImg(i,j) = sqrt( vImg(i,j)^2 + hImg(i,j)^2 );% ←ここを修正する
    end
end
subplot(2,4,3); imagesc(intensityImg); axis equal; colormap('gray'); title('エッジの強度');

%% エッジの方位を計算 -----------------------------------------------------------
orientationImg = zeros(h,w);
for i=1:h% 画像の行方向ループ，これはフィルタリングじゃないので，はみ出しは気にしない
    for j=1:w% 画像の列方向ループ
        orientationImg(i,j) = atan2(vImg(i,j), hImg(i,j));% ←ここを修正する
    end
end
subplot(2,4,4); imagesc(orientationImg); axis equal; colormap('gray'); title('エッジの方位');

%% 閾値処理で斜め線だけ残るように -----------------------------------------------------------
Thresh = 20;% エッジの強さのしきい値（自分で適当に決める）
targetOrientation = deg2rad(60);% 検出したい方向 [rad]
OrientalThreshDeg=4.2;
for i=1:h% 画像の行方向ループ
    for j=1:w% 画像の列方向ループ
        if intensityImg(i,j) >= Thresh && abs(orientationImg(i,j)-targetOrientation) <= deg2rad(OrientalThreshDeg)% ←ここを修正する
            vImg(i,j) = 255.0;
        else
            vImg(i,j) = 0;
        end
    end
end
subplot(2,4,8); imagesc(vImg); axis equal; colormap('gray'); title('しきい値処理');

timestamp = datestr(now, 'yyyy_mmdd_HHMM');% 現在時刻を取得して、フォーマットする
filename = [timestamp, '.png'];% ファイル名を作成
saveas(gcf, filename)