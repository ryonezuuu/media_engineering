clear; close all; clc;
% 画像の引用元--------------------------------------------------------------
% img1 -> https://www.photock.jp/photo/big/photo0000-6368.jpg
% img2 -> https://www.pexels.com/ja-jp/photo/464332/
% img3 -> https://www.istockphoto.com/jp/
% img4 -> https://photock.jp/detail/maeda-forest-park/
% img5 -> https://photock.jp/detail/umi-no-nakamichi-22/
% img6 -> https://photock.jp/detail/jr-kyushu-811-series-train-kashii-station/

% ファイル読み込み ---------------------------------------------------------
% 学籍番号に応じて使う画像を変える（下2桁が奇数:img1, 偶数:img2）
img = imread('imgB.jpg');%

[h, w, ch] = size(img);% 画像サイズを確認

r_vec = reshape( double(img(:,:,1))/255.0, [1, h*w]);
g_vec = reshape( double(img(:,:,2))/255.0, [1, h*w]);
b_vec = reshape( double(img(:,:,3))/255.0, [1, h*w]);

hsvImg = rgb2hsv( img );% double型(0~1.0)
hue_vec = reshape(hsvImg(:,:,1), [1, h*w]);% Hueを１次元の配列に
sat_vec = reshape(hsvImg(:,:,2), [1, h*w]);% Saturationを１次元の配列に
val_vec = reshape(hsvImg(:,:,3), [1, h*w]);% Valueを１次元の配列に

iro_mihon = imread('hsv.bmp');% hsvの色見本画像

%% 色を事前に調べる
% H, S, V を適当な範囲で動かしていき，その条件に該当するがその数を調べていく
hue_list = 0:0.2:1.0;% Hueのリスト
sat_list = [0, 0.33, 0.66, 1.0];% Saturationのリスト
val_list = [0, 0.33, 0.66, 1.0];% Valueのリスト

num = 0;% 条件数をリセット
result_mat = [];% 空の配列に
for i=1:length(hue_list)-1% リストの数-1だけループ
    for j=1:length(sat_list)-1
        for k=1:length(val_list)-1
            hue_upperLimit = hue_list(i+1);% 色相の上限
            hue_underLimit = hue_list(i);% 色相の下限
            sat_upperLimit = sat_list(j+1);% 彩度の上限
            sat_underLimit = sat_list(j);% 彩度の下限
            val_upperLimit = val_list(k+1);% 明度の上限
            val_underLimit = val_list(k);% 明度の下限

            % その色の範囲にある画素の数
            hue_match_idx = hue_vec >= hue_underLimit & hue_vec <= hue_upperLimit;% 条件にあったインデックス
            sat_match_idx = sat_vec >= sat_underLimit & sat_vec <= sat_upperLimit;% 条件にあったインデックス
            val_match_idx = val_vec >= val_underLimit & val_vec <= val_upperLimit;% 条件にあったインデックス

            all_match_idx = hue_match_idx .* sat_match_idx .* val_match_idx;% ３条件の&をとる

            mean_h = mean( hue_vec(find(all_match_idx)));% HSVの平均を計算する
            mean_s = mean( sat_vec(find(all_match_idx)));
            mean_v = mean( val_vec(find(all_match_idx)));

            [mean_r, mean_g, mean_b] = hsv2rgb([mean_h, mean_s, mean_v]);% RGBに変換する
            % disp([i,j,k,sum(all_match_idx)]);

            num = num + 1;% 条件数を１つ増やす
            result_mat(num,1) = i;% Hueのインデックス
            result_mat(num, 2) = j;% Saturationのインデックス
            result_mat(num, 3) = k;% Valueのインデックス
            result_mat(num, 4) = sum(all_match_idx);% 条件に合致した
            result_mat(num, 5) = mean_h;% 平均 Hue
            result_mat(num, 6) = mean_s;% Saturation
            result_mat(num, 7) = mean_v;% Value
            result_mat(num, 8) = mean_r;% 平均 Red
            result_mat(num, 9) = mean_g;% Green
            result_mat(num, 10) = mean_b;% Blue
        end
    end
end

[tmp, sorted_order] = sort( result_mat(:,4), 'descend' );% 合致した個数でソート

for i=1:length(sorted_order)
    sorted_result_mat(i, 1:10) = result_mat( sorted_order(i), 1:10);%
end

figure,% 45個の色見本を表示して目視で確認（ここが超絶ダサイ）
n=0;
for i = 1:num
    n = n + 1;
    tmpImg(1,1,1:3) = hsv2rgb( sorted_result_mat(i,5:7) );
    subplot(5,9,i);
    imshow(tmpImg);
    title(n);
end
%% 代表色を決める
useColorIdx = [1, 2, 3, 23, 40, 39, 38, 14, 12, 29, 7];% 主観で，恣意的に決めた11個の代表色
figure,% 
n=0;
for i = 1:length(useColorIdx)
    tmp = useColorIdx(i);
    tmpImg(1,1,1:3) = hsv2rgb( sorted_result_mat(tmp,5:7) );
    subplot(3,4,i);
    imshow(tmpImg);
    title(tmp);
end

use_result_mat = sorted_result_mat(useColorIdx,:);
kyori_mat = zeros( length(hue_vec), 11);
for i=1:length( useColorIdx )
    tmpNum = useColorIdx(i);
    target_r = sorted_result_mat(tmpNum, 8);% 代表色を取り出す
    target_g = sorted_result_mat(tmpNum, 9);
    target_b = sorted_result_mat(tmpNum, 10);

    sabun_r_mat = r_vec - target_r;% Redを格納した行列と代表色の差分
    sabun_g_mat = g_vec - target_g;
    sabun_b_mat = b_vec - target_b;

    sabun_all_mat = sqrt( sabun_r_mat.^2 + sabun_g_mat.^2 + sabun_b_mat.^2);% HSV空間での代表色との距離

    kyori_mat(:,i) = sabun_all_mat';% 転置して代入
end

[M, min_idx] = min(kyori_mat, [], 2);% 各行の最小値とそのインデックスを返す

min_mat = reshape(min_idx, [h, w]);

% 減色画像を作る -----------------------------------------------------------
outImg = zeros( h, w, ch);
for i=1:h
    for j=1:w
        use_color_id = min_mat(i,j);
        r = use_result_mat(use_color_id, 8);
        g = use_result_mat(use_color_id, 9);
        b = use_result_mat(use_color_id, 10);

        outImg(i,j,:) = [r, g, b];% この時点ではdouble型(0~1.0)
    end
end

figure,
subplot(1,2,1); imshow(img); title('オリジナル');
subplot(1,2,2); imshow(outImg); title('色数を減らした画像');
% imwrite(uint8(255.0*outImg), 'kadai3_C11_20XX531XYZ.bmp');% 自分の学籍番号にすること
