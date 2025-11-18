clear; close all; clc;
img = imread('teikou_4.png');
% img = imread('teikou.jpg');
img = imresize(img, 2);% 拡大
img = im2double(img); % これをしないとvalが正規化されない
imshow(img);

roi1 = drawrectangle('Label','1st');% Region of Interest
roi2 = drawrectangle('Label','2nd');
roi3 = drawrectangle('Label','3rd');

x1 = round( roi1.Position(1) + (1:roi1.Position(3)) );% 1桁目
y1 = round( roi1.Position(2) + (1:roi1.Position(4)) );
img1 = img(y1, x1, :);

x2 = round( roi2.Position(1) + (1:roi2.Position(3)) );% 2桁目
y2 = round( roi2.Position(2) + (1:roi2.Position(4)) );
img2 = img(y2,x2, :);

x3 = round( roi3.Position(1) + (1:roi3.Position(3)) );% 3桁目
y3 = round( roi3.Position(2) + (1:roi3.Position(4)) );
img3 = img(y3,x3, :);

figure,
subplot(1,3,1); imshow(img1);
subplot(1,3,2); imshow(img2);
subplot(1,3,3); imshow(img3);

img1_RGB = mean(mean(img1));% 各領域の平均RGBを抽出
img2_RGB = mean(mean(img2));
img3_RGB = mean(mean(img3));

img1_HSV = rgb2hsv(img1_RGB);
img2_HSV = rgb2hsv(img2_RGB);
img3_HSV = rgb2hsv(img3_RGB);

colorCode = [hsv2num(img1_HSV) hsv2num(img2_HSV) hsv2num(img3_HSV)];
resistance = (10*colorCode(1) + colorCode(2))* (10^colorCode(3));
disp(['抵抗値は ', num2str(resistance), 'Ω です。']);

function num = hsv2num(img_HSV)
   hueBoarder = [0.08, 0.13, 0.19, 0.48, 0.72, 0.82];
   hue = img_HSV(1,1,1);
   sat = img_HSV(1,1,2);
   val = img_HSV(1,1,3);
   if val < 0.35% 明度が低いならば
       num = 0;% 黒
   else% 明度が高いならば
       if sat < 0.16% 彩度が低いならば（無彩色にする）
           if val < 0.9% 明度が低いならば
               num = 8;% 灰
           else% 明度が高いならば
               num = 9;% 白
           end
       else% 彩度が高いならば（有彩色にする）
           num = 1;% 暫定的に赤にしておく
           for k=2:length( hueBoarder )% (境界線の数-1)だけループ
               if hue > hueBoarder(k-1) && hue <= hueBoarder(k)
                   num = k+1;% +3 は無彩色（黒，灰，白）の分だけテーブルをずらすため
               end
           end
           if num == 1
                if sat > 0.8
                    num = 2;
                end
           end
       end
   end
end