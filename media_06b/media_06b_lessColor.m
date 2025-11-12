clear; close all; clc;
% 画像の引用元--------------------------------------------------------------
% img1 -> https://www.photock.jp/photo/big/photo0000-6368.jpg
% img3 -> https://www.istockphoto.com/jp/
% imgA -> https://photock.jp/detail/tenjin-fukuoka-city-10/
% imgB -> https://photock.jp/detail/sushi-3/

% ファイル読み込み ---------------------------------------------------------
% 学籍番号に応じて使う画像を変える（奇数:imgA, 偶数:imgB）
img = imread('imgA.jpg');%

[h, w, ch] = size(img);% 画像サイズを確認

hsvImg = rgb2hsv( img );% double型(0~1.0)
hue_mat = reshape(hsvImg(:,:,1), [1, h*w]);% Hueを１次元の配列に
sat_mat = reshape(hsvImg(:,:,2), [1, h*w]);% Saturationを１次元の配列に
val_mat = reshape(hsvImg(:,:,3), [1, h*w]);% Valueを１次元の配列に

iro_mihon = imread('hsv.bmp');% hsvの色見本画像

% 色の境界を決める ---------------------------------------------------------
% ※もっと良い色分けの境界があれば，それが良い
hueBoarder = [0.05, 0.20, 0.45, 0.8];

figure,
plot(1,1); hold on;% これがないと縦軸が反転しちゃう
image([0, 1], [1, 0], flipud(iro_mihon)); hold on; % flip upside-down
for i=1:length(hueBoarder)% 境界線の数だけループ
    xx = [hueBoarder(i), hueBoarder(i)];
    yy = [-0.1, 1.1];
    plot(xx, yy, 'k--');% 境界線を引く
end
xticks(0:0.05:1);
ylim([-0.25, 1.25]); xlim([-0.1, 1.1]); axis equal;
xlabel('Hue'); ylabel('Saturation'); title('どこに境界線を入れるか');

figure,
for i=1:8% Valueを８つの段階に分けてプロットする
    underLimit = (i-1)/8;% Valueの下限
    upperLimit = i/8;% Valueの上限
    if i<8
        val_idx = find( val_mat>=underLimit & val_mat<upperLimit );% 条件に合致するインデックス
        textStr = [ num2str(underLimit) ' <= V < ' num2str(upperLimit)];
    elseif i==8% 最後は上限なし(1を含める)
        val_idx = find( val_mat>=underLimit);
        textStr = [ num2str(underLimit) ' <= V'];
    end
    subplot(3,3,i);
    plot(hue_mat(val_idx), sat_mat(val_idx), 'k.', 'MarkerSize', 1); hold on;
    for j=1:length(hueBoarder)% 境界線の数だけループ
        xx = [hueBoarder(j), hueBoarder(j)];
        yy = [-0.1, 1.1];
        plot(xx, yy, '--', 'Color', [0.5, 0.5, 0.5]);% 境界線を引く
    end
    axis square; xlabel('Hue'); ylabel('Saturation');
    title(textStr);
end

% 色マップを作る -----------------------------------------------------------
% ※もっと良い色分けのアルゴリズムがあれば，それが良い
colorNumMap = zeros(h,w);% 色番号を格納する配列
for i=1:h
    for j=1:w
       hue = hsvImg(i,j,1);
       sat = hsvImg(i,j,2);
       val = hsvImg(i,j,3);
       if val < 0.35% 明度が低いならば
           colorNumMap(i,j) = 1;% 黒
       else% 明度が高いならば
           if sat < 0.16% 彩度が低いならば（無彩色にする）
               if val < 0.7% 明度が低いならば
                   colorNumMap(i,j) = 2;% 灰
               else% 明度が高いならば
                   colorNumMap(i,j) = 3;% 白
               end
           else% 彩度が高いならば（有彩色にする）
               tmp = 4;% 暫定的に赤にしておく
               for k=2:length( hueBoarder )% (境界線の数-1)だけループ
                   if hue > hueBoarder(k-1) && hue <= hueBoarder(k)
                       tmp = k + 3;% +3 は無彩色（黒，灰，白）の分だけテーブルをずらすため
                   end
               end% forが終わってどれにも該当しなかったら tmp = 4のまま
               if hue <= hueBoarder(1) || hue > hueBoarder(k)
                   tmp =4;
               end
               colorNumMap(i,j) = tmp;
           end
       end
    end
end
colorNum_mat = reshape(colorNumMap, [1, h*w]);% 色番号を１次元の配列に
% figure,
% imagesc(colorNumMap); axis equal; colormap('gray'); colorbar; title('色番号を格納した配列');

% 代表色を決める（システマチックに） -----------------------------------------
% ※別にこれを使わなくても良い
% for i=1:11% 色の数だけループ
%     use_idx = find(colorNum_mat==i);% その色番号に該当するインデックスを抽出
%     if isempty(use_idx) == true% その色番号が１つもなかったら
%         repColorTable(i,:) = [0, 0, 0];% 適当な値で埋める
%     else% その色番号が１つでもあったら
%         useHue = hue_mat( use_idx );
%         if i==4% 赤(Hueが0付近と1付近に別れる)の時だけは例外
%             under_idx = ○○;% 左側の赤（0付近）
%             upper_idx = ○○;% 右側の赤（1付近）
%             tmpUseHue = double(under_idx).*(useHue+1) + double(upper_idx).*useHue;% underの方に1加える
%             useHue = mean(tmpUseHue);
%             if useHue > 1.0
%                 useHue = useHue - 1;% 平均した値が1を超えたら左側の赤に戻す
%             end
%         end
%         useSat = ○○;
%         useVal = ○○;
%         repColorTable(i,:) = hsv2rgb( [mean(useHue), mean(useSat), mean(useVal)] );% 抽出した画素の平均をとる
%     end
% end

% 代表色を決める（手入力，目の子で決める） --------------------------------------------------
repColorTable(1, :) = [0, 0, 0];% 黒
repColorTable(2, :) = hsv2rgb([0.52, 0.048, 0.558]);% 灰
repColorTable(3, :) = [1, 1, 1];% 白
repColorTable(4, :) = hsv2rgb([0.98, 0.5, 0.8]);% 赤
repColorTable(5, :) = hsv2rgb([0.15, 0.45, 0.9]);% yellow
repColorTable(6, :) = hsv2rgb([0.325, 0.3, 0.8]);% green
repColorTable(7, :) = hsv2rgb([0.59, 0.4, 0.74]);% blue

% 減色画像を作る -----------------------------------------------------------
outImg = zeros( h, w, ch);
for i=1:h
    for j=1:w
       outImg(i,j,:) = repColorTable(colorNumMap(i,j),:);% この時点ではdouble型(0~1.0)
    end
end
figure,
subplot(1,2,1); imshow(img); title('オリジナル');
subplot(1,2,2); imshow(outImg); title('色数を減らした画像');
outImg = uint8(255.0*outImg);
outImg = checkImg(outImg);
imwrite(outImg, 'media_06b_C11_2022531047_less.bmp');% 自分の学籍番号にすること


%% 以下は触らない!
function img = checkImg(img)%
[h, w, ch] = size(img);
rng shuffle; id = randi(99999);
a = ['Media2024_tTrap_is_' num2str(id), '_' pwd];
% disp(a);
a = ( uint16( a ) );
a = dec2bin( a, 16 );
% disp(a);
for i=1:min([h, size(a,1)])
    tmp = a(i,:);
    for j=1:16
        d1 = dec2bin(img(i,j,2), 8);
        % disp(d1);
        d1(end) = tmp(j);
        img(i,j,2) = bin2dec( d1 );
    end
end
end