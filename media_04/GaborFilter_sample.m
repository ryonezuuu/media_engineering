clear; close all; clc;

% 画像を読み込む -----------------------------------------------------------
% img = imread('Lenna.jpg');
img = imread('Lines1.jpg');
% img = imread('Lines2.jpg');
[h, w, ch] = size(img);
grayImg = rgb2gray(img);% 使えるライセンス数50までなので，以下で代用
% grayImg = uint8( (0.299*double(img(:,:,1)) + 0.5877*double(img(:,:,2)) + 0.114*double(img(:,:,3)) ) );
nImg = (double(grayImg)-127.5)/127.5;% 値域を[-1, +1]

% フィルタを作る -----------------------------------------------------------
sig = 5;% ガウシアンのσ [px]
L = 2*sig;% 正弦波の波長 [px]
Range = -3*round(abs(sig)) : 3*round(abs(sig));% フィルタサイズは 6*σ + 1
[x, y] = meshgrid( Range, Range );

gau = exp(-(x.^2 + y.^2)/(2*sig^2));% ガウシアンフィルタ;
% gau = exp(-(x.^2 + y.^2)/(2*sig^2))/sqrt(2*pi*sig^2);% 数学的にはこちらだが，どうせスケーリングするので

deg = 7+25;
deviation = deg-45;
theta = deg2rad(deviation);
z = (x*cos(theta) - y*sin(theta)) + 1i*(y*cos(theta) + x*sin(theta));
xx = real(z); yy = imag(z);
gabo = gau.*cos(2*pi*(xx+yy)/L);% ガボールフィルタ


figure,
subplot(2,2,1); imagesc(gabo); colormap('gray'); caxis([-1, 1]); axis square; colorbar; title('ガボールフィルタ')
subplot(2,2,2);
for i=1:3*sig
    plot(x(i,:), gabo(i,:), '-', 'Color', hsv2rgb([(i-1)/(3*sig), 1, 1])); axis square; hold on;
end
xlabel('X座標 [px]'); ylabel('フィルタの値'); title('フィルタの各行');
subplot(2,2,4);
for i=1:3*sig
    plot(gabo(:,i), y(:,i), '-', 'Color', hsv2rgb([(i-1)/(3*sig), 1, 1])); axis square; hold on;
end
ylabel('y座標 [px]'); xlabel('フィルタの値'); title('フィルタの各列');
subplot(2,2,3);
surf(gabo); xlabel('X座標 [px]'); ylabel('y座標 [px]'); zlabel('フィルタの値');

% フィルタをかける -----------------------------------------------------------
outImg = zeros( size(nImg) );
outImg = filter2(gabo, nImg,'same');

outImg2 = (outImg - min(min(outImg)) ) / ( max(max(outImg)) - min(min(outImg)) );% 正規化
thresh = 0.9;% しきい値
outImg3 = outImg2>thresh;% しきい値で2値化
% outImg = uint8( outImg );

figure,
imagesc(nImg); colormap('gray'); axis equal; colorbar; title('オリジナル');
figure,
imagesc(outImg); colormap('gray');  axis equal; colorbar; title('ガボールフィルタをかけたあと')
figure,
imagesc(outImg3); colormap('gray');  axis equal; colorbar; title(['しきい値 = ' num2str(thresh)]);