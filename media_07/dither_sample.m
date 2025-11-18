clear; close all; clc;
N = 256;

origGradImg = zeros(N,N,3);
for i=1:N
    origGradImg(i,:,1) = 1.0 - double( (i-1)/(N-1));
    origGradImg(i,:,2) = 1.0 - double( (i-1)/(N-1));
    origGradImg(i,:,3) = 1.0;
end

ditherGradImg = ones(N,N,3);
for i=1:2:N
    for j=1:2:N
        if i<52% 先頭の20%
            % 全部白のまま
        elseif i<103% 21~40%
            ditherGradImg(i,j,1:2) = 0.0;% 1/4だけ青に
        elseif i<154% 41~60%
            ditherGradImg(i,j,1:2) = 0.0;% 2/4だけ青に
            ditherGradImg(i+1,j+1,1:2) = 0.0;
        elseif i<205% 61~80%
            ditherGradImg(i,j+1,1:2) = 0.0;% 3/4だけ青に
            ditherGradImg(i+1,j,1:2) = 0.0;
            ditherGradImg(i+1,j+1,1:2) = 0.0;
        else% 81~100%
            ditherGradImg(i,j,1:2) = 0.0;% 4/4を青に
            ditherGradImg(i+1,j,1:2) = 0.0;
            ditherGradImg(i,j+1,1:2) = 0.0;
            ditherGradImg(i+1,j+1,1:2) = 0.0;
        end
    end
end

figure,
subplot(1,2,1); imshow( uint8(255.0*origGradImg) ); title('オリジナルのグラデーション');
subplot(1,2,2); imshow( uint8(255.0*ditherGradImg) ); title('ディザ法のグラデーション');