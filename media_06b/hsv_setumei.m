clear; close all; clc;

% 色見本を作る -------------------------------------------------------------
[x, y] = meshgrid(0:0.01:1, 0:0.01:1);

figure, 
for i=1:9
    val = (9-i)/8;
    subplot(3,3,i);
    sampleHsvImg(:,:,1) = x;
    sampleHsvImg(:,:,2) = flipud(y);
    sampleHsvImg(:,:,3) = val;
    imshow( hsv2rgb( sampleHsvImg) ); axis equal; title(['Value = ' num2str(val)]);
end
