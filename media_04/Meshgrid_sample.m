clear; close all; clc;

Range = -100:100;
[x, y] = meshgrid(Range, Range);

ori = 45;% ‰ñ“]Šp“x [‹] -> cos‚âsin‚Ì’†‚ÅŽg‚¤‚Æ‚«‚É‚Í’PˆÊ‚ð[rad]‚É‚·‚é•K—v‚ª‚ ‚é 
newX = x;% ‚±‚Á‚¿‚ÍŽg‚í‚È‚¢‚¯‚Ç
newY = y;% ‚±‚±‚Å‰ñ“]‚ð•\Œ»‚·‚é

figure, 
subplot(2,3,1); imagesc(x); colormap('gray'); colorbar; axis equal; title('x');
subplot(2,3,2); imagesc(y); colormap('gray'); colorbar; axis equal; title('y');
subplot(2,3,3); imagesc(newY); colormap('gray'); colorbar; axis equal; title(['\theta =' num2str(ori)]);

subplot(2,3,4); imagesc(sin(2*pi*x/100)); colormap('gray'); colorbar; axis equal; title('sin(x)');
subplot(2,3,5); imagesc(sin(2*pi*y/100)); colormap('gray'); colorbar; axis equal; title('cos(y)');
subplot(2,3,6); imagesc(sin(2*pi*newY/100)); colormap('gray'); colorbar; axis equal; title('ŽÈ‚ÌŽ²‚ð‰ñ“]');