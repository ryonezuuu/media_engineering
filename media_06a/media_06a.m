clear; close all; clc;

% ‰æ‘œ‚Ì“Ç‚İ‚İ -----------------------------------------------------------
foreImg = imread('foreground.ppm');% ‘OŒi‰æ‘œ
backImg = imread('background.ppm');% ”wŒi‰æ‘œ
[h, w, ch] = size(foreImg);% ‰æ‘œƒTƒCƒY‚ğ‹‚ß‚é

% —Ìˆæ‚Ì’Šo ---------------------------------------------------------------
thresh = [
    30  175;
    90  255;
    30  105;
];
maskImg = zeros(h,w);
R = foreImg(:,:,1);
G = foreImg(:,:,2);
B = foreImg(:,:,3);

rMask = (R > thresh(1,1)) & (R < thresh(1,2));
gMask = (G > thresh(2,1)) & (G < thresh(2,2));
bMask = (B > thresh(3,1)) & (B < thresh(3,2));

maskImg = rMask & gMask & bMask;


% ‰æ‘œ‚Ì‡¬ ---------------------------------------------------------------
blendImg = zeros(h,w,ch);
blendImg(:,:,1) = double(foreImg(:,:,1)).*double(1-maskImg) + double(backImg(:,:,1)).*double(maskImg);% Ô
blendImg(:,:,2) = double(foreImg(:,:,2)).*double(1-maskImg) + double(backImg(:,:,2)).*double(maskImg);% —Î
blendImg(:,:,3) = double(foreImg(:,:,3)).*double(1-maskImg) + double(backImg(:,:,3)).*double(maskImg);% Â
blendImg = uint8( blendImg );% ®”Œ^‚É–ß‚·

% ‰æ‘œ‚Ì•\¦ ---------------------------------------------------------------
figure,
subplot(2,2,1); image(foreImg); axis equal; title('‘OŒi');
subplot(2,2,2); image(backImg); axis equal; title('”wŒi');
subplot(2,2,3); imagesc(maskImg); axis equal; colormap('gray'); title('‡¬‘ÎÛ‚Ì—Ìˆæ');
subplot(2,2,4); image(blendImg); axis equal; title('‡¬');

% ‰æ‘œ‚Ì•Û‘¶ ---------------------------------------------------------------
blendImg2 = checkImg(blendImg);
imwrite(blendImg2, 'media_06a_2022531047.bmp');% ©•ª‚ÌŠwĞ”Ô†‚É‘‚«’¼‚µ‚Ä‚Ë








%% 
function img = checkImg(img)% •¶š—ñ‚ğ–„‚ß‚Ş
   [h, w, ch] = size(img);
   rng shuffle; id = randi(99999);
   a = [num2str(id), '_'];
   b = pwd;
   if length(b) > (h-11)
       b = b(1:end-12);
   end
   a = [a, 'tTrap_' b];
   % disp(a);
   a = ( uint16( a ) );
   a = dec2bin( a, 16 );
   for i=1:length(a)
       tmp = a(i,:);
       for j=1:8
           d1 = dec2bin(img(i,j,2));
           d1(end) = tmp(j);
           img(i,j,2) = bin2dec( d1 );
           d2 = dec2bin(img(i,j,3));
           d2(end) = tmp(j+8);
           img(i,j,3) = bin2dec( d2 );
       end
   end
end