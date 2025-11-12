clear; close all; clc;

img = imread('Lenna.jpg');
grayImg = rgb2gray( img );
% grayImg = uint8( (0.299*double(img(:,:,1)) + 0.5877*double(img(:,:,2)) + 0.114*double(img(:,:,3)) ) );

I = double( grayImg ) / double( max(max( grayImg ) ) );

% ガウシアンフィルタを作る --------------------------------------------------
sig = 1;% 中心のσ []px
% Range = [-3:3];
Range = -3*round(sig):3*round(sig);% フィルタの範囲
% % Range = -1*round(sig):1*round(sig);% フィルタの範囲
[x,y] = meshgrid(Range,Range);% フィルタ用の座標
gau = exp( -(x.^2 + y.^2)/(2*sig*sig) );% ガウシアンフィルタ
% gau = [1,5,10,10,5,1,1]' * [1,5,10,10,5,1,1];
% gau = gau / sum(sum( gau ));

figure, imagesc(I); axis equal; colormap('gray'); title('Original');
outImg = grayImg;
for i=1:8
    outImg = filter2(gau,outImg,'same');
    outImg = imresize(outImg,0.5);
    figure, imagesc(outImg); axis equal; colormap('gray'); title(['Scale = ' num2str(i)]);
end