clear; close all; clc;

% 画像を読み込む -----------------------------------------------------------
% img = imread('Lenna.jpg');
img = imread('bb.png');
grayImg = rgb2gray(img);% 使えるライセンス数50までなので，以下で代用
% grayImg = uint8( (0.299*double(img(:,:,1)) + 0.5877*double(img(:,:,2)) + 0.114*double(img(:,:,3)) ) );

% フィルタを作る -----------------------------------------------------------
sig = 3;% ガウシアンのσ [px]
Range = -3*round(abs(sig)) : 3*round(abs(sig));% フィルタサイズは 6*σ + 1
[x, y] = meshgrid( Range, Range );

gau = exp(-(x.^2 + y.^2)/(2*sig^2));% ガウシアンフィルタ;
% gau = exp(-(x.^2 + y.^2)/(2*sig^2))/sqrt(2*pi*sig^2);% 数学的にはこちらだが，どうせスケーリングするので

figure,
subplot(2,2,1); imagesc(gau); colormap('gray'); axis square; colorbar; title('ガウシアンフィルタ')
subplot(2,2,2);
for i=1:3*sig
    plot(x(i,:), gau(i,:), '-', 'Color', hsv2rgb([(i-1)/(3*sig), 1, 1])); axis square; hold on;
end
xlabel('X座標 [px]'); ylabel('フィルタの値'); title('フィルタ中央の行');
subplot(2,2,4);
for i=1:3*sig
    plot(gau(:,i), y(:,i), '-', 'Color', hsv2rgb([(i-1)/(3*sig), 1, 1])); axis square; hold on;
end
ylabel('y座標 [px]'); xlabel('フィルタの値'); title('フィルタ中央の列');
subplot(2,2,3);
surf(gau); xlabel('X座標 [px]'); ylabel('y座標 [px]'); zlabel('フィルタの値');

% フィルタをかける -----------------------------------------------------------
outImg = zeros( size(grayImg) );
outImg = filter2(gau, double(grayImg),'same');
% outImg = uint8( outImg );

figure,
imagesc(grayImg); colormap('gray'); axis equal; title('オリジナル')
figure,
imagesc(outImg); colormap('gray'); axis equal; title('ガウシアンフィルタをかけたあと')