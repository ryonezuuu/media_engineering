clear; close all; clc;
img = imread('scintillating_grid-McAnany-Levine-extinctionillusion2016c.jpg');
grayImg = rgb2gray(img);% 使えるライセンス数50までなので，以下で代用
% grayImg = uint8( (0.299*double(img(:,:,1)) + 0.5877*double(img(:,:,2)) + 0.114*double(img(:,:,3)) ) );

figure, 
imagesc( grayImg ); colormap('gray'); axis square; colorbar;
% ガウシアン
sig1 = 2;
sig2 = 1.5*sig1;
Range = -3*round(sig2):3*round(sig2);
[x, y] = meshgrid(Range, Range);

gau1 = exp(-(x.^2+y.^2)/(2*sig1*sig1));
gau2 = exp(-(x.^2+y.^2)/(2*sig2*sig2));
DoG = gau1 - 0.5*gau2;

figure, 
subplot(2,2,1); 
imagesc( DoG ); caxis([-1, 1]); colormap('gray'); axis square; colorbar;
subplot(2,2,[2, 4]); 
plot( x(round(length(y)/2),:) ,DoG(round(length(y)/2),:) , '-');  hold on;
plot( x(round(length(y)/2),:) , gau1(round(length(y)/2),:) , 'r-'); hold on;
plot( x(round(length(y)/2),:) , gau2(round(length(y)/2),:) , 'g-'); hold on;
% ylim([-0.25, 1.25]);
xlabel('X [px]');
legend('DoG','Gaussian(\sigma=2)','Gaussian(\sigma=2*1.5)');
% フィルタリング
nImg = (double(grayImg) - 127.5)/127.5;% 値域を [0 255] から [-1 1]に
outImg = filter2(DoG, nImg, 'same');

subplot(2,2,3);
surf(DoG); xlabel('X座標 [px]'); ylabel('y座標 [px]'); zlabel('フィルタの値');

figure,
imagesc( outImg ); colormap('gray'); axis square; colorbar;