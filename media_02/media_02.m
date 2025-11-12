clear; close all; clc;

data = readmatrix('output.csv');
% ヘッダが付いていないが，左から，
% ユーザー，画像番号，何番目（に注目したか），X座標，Y座標

%% データの抽出
% ----- １番目に注目した画素の座標を収集する
posList_img1_1st = data(1:9:end, 4:5);

% 行がユーザー番号，列が座標（1列目がX，2列目がY）
% 1:9:end というインデックスの指定方法は，「先頭から，9つ飛ばしで，最後まで」の意味
% ※　ただし，これだ欠損データあったときに順番が狂うという問題がある

% ----- ２番目に注目した画素の座標を収集する
[idx, val] = find(data(:,2)==1 & data(:,3)==2);
% disp([val, idx]);% 確認用
posList_img1_2nd = data(idx, 4:5);

% data(:,2)==1 でユーザー番号が1と一致するかどうかを調べる
% data(:,3)==2 で何番目に注目したかが2と一致するかどうかを調べる
% そのANDを取ったもの = TrueまたはFalseが入った配列（元のデータの行数と同じ）
% find()でその配列の非ゼロの項のみを見つける（idxは元の配列でのインデックス，val(ue)は全部1(True)）

% ----- それ以外も収集する（未完成）
[idx, val] = find(data(:,2)==1 & data(:,3)==3);
posList_img1_3rd = data(idx, 4:5);

% とはいえ，3回分を分けて収集するのは面倒といえば，面倒
posList_img2 = data( find(data(:,2)==2), 3:5);
% これで img2 の 何番目か，x座標，y座標という配列が取り出せるので集計の方をアレンジする

posList_img1 = data( find(data(:,2)==1), 3:5);
posList_img3 = data( find(data(:,2)==3), 3:5);
%% 集計
% ----- img1 について
img1 = imread('img_1.jpg');
[img1_height, img1_width, ~] = size(img1);
img1_result = zeros(img1_height, img1_width);% 配列を宣言するときは，行→列の順番
sig=5;
for i=1:length(posList_img1)% リストの長さ分だけループ
    axy = posList_img1(i,:);
    amp = axy(1);
    x = axy(2);
    y = axy(3);
    for yy = -3*sig:3*sig
        for xx = -3*sig:3*sig
            val = exp(-(xx^2 + yy^2)/(2*sig^2));% ガウス分布の値を計算
            yi = y+yy;
            xi = x+xx;
            if  0<yi && yi<img1_height && 0<xi && xi<img1_width% はみ出し防止
               img1_result(yi, xi) = img1_result(yi, xi) + val*(4-amp);% 順位に応じて加点
            end
        end
    end
end

%% 
% ----- img2 について
img2 = imread('img_2.jpg');
[img2_height, img2_width, ~] = size(img2);
img2_result = zeros(img2_height, img2_width);%
sig = 5;% ２次元ガウス関数の広がりを決める定数 [px]
for i=1:length(posList_img2)% リストの長さ分だけループ
    axy = posList_img2(i,:);
    amp = axy(1);% 本当は意味の通る変数名がいいが，これは適当，順位（何場面に注目したか）
    x = axy(2);
    y = axy(3);
    for yy = -3*sig:3*sig
        for xx = -3*sig:3*sig
            val = exp(-(xx^2 + yy^2)/(2*sig^2));% ガウス分布の値を計算
            yi = y+yy;
            xi = x+xx;
            if  0<yi && yi<img2_height && 0<xi && xi<img2_width% はみ出し防止
               img2_result(yi, xi) = img2_result(yi, xi) + val*(4-amp);% 順位に応じて加点
            end
        end
    end
end

% ----- img3 について
img3 = imread('img_3.jpg');
[img3_height, img3_width, ~] = size(img3);
img3_result = zeros(img3_height, img3_width);%
sig = 5;% ２次元ガウス関数の広がりを決める定数 [px]
for i=1:length(posList_img3)% リストの長さ分だけループ
    axy = posList_img3(i,:);
    amp = axy(1);% 本当は意味の通る変数名がいいが，これは適当，順位（何場面に注目したか）
    x = axy(2);
    y = axy(3);
    for yy = -3*sig:3*sig
        for xx = -3*sig:3*sig
            val = exp(-(xx^2 + yy^2)/(2*sig^2));% ガウス分布の値を計算
            yi = y+yy;
            xi = x+xx;
            if  0<yi && yi<img3_height && 0<xi && xi<img3_width% はみ出し防止
               img3_result(yi, xi) = img3_result(yi, xi) + val*(4-amp);% 順位に応じて加点
            end
        end
    end
end



%% 結果を表示
figure, 
subplot(2,3,1);% Subplotの考え方も行列と同じ，３つ目はインデックス
imshow(img1); axis equal; %colorbar;
title('Img1');

subplot(2,3,4);
imagesc(img1_result); axis equal; %colorbar; %axis equal;
title('img1 で注目された箇所');
% ユーザーの回答が１画素単位で一致することはまずないので，この可視化はあまりうまくいっていない

subplot(2,3,2);% 
imshow(img2); axis equal; %colorbar;
title('Img2');

subplot(2,3,5);
imagesc(img2_result); axis equal; %colorbar; %axis equal;
title('img2 で注目された箇所');

subplot(2,3,3);% Subplotの考え方も行列と同じ，３つ目はインデックス
imshow(img3); axis equal; %colorbar;
title('Img3');

subplot(2,3,6);
imagesc(img3_result); axis equal; %colorbar; %axis equal;
title('img3 で注目された箇所');

% プログラムが完成した以下のコメントアウトを解除する
timestamp = datestr(now, 'yyyy_mmdd_HHMM');% 現在時刻を取得して、フォーマットする
filename = [timestamp, '.png'];% ファイル名を作成
% save(filename)
saveas(gcf, filename);