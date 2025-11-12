clear all; close all; clc;

img = imread('Lenna.jpg');

x = 0:0.001:5;
y1 = x;
y2 = x.^2;
y3 = x.^3;

% 構造体
myStructure.img = img;% myStrcureという構造体のメンバ img に 配列imgの値を格納
myStructure.x = x;% myStrcureという構造体のメンバ x に 変数xの値を格納
myStructure.y = y1;% myStrcureという構造体のメンバ y1 に 変数yの値を格納

figure,
subplot(1,2,1); 
image( myStructure.img ); axis equal; title('構造体のメンバ img');
subplot(1,2,2); plot(myStructure.x, myStructure.y, 'b-'); title('構造体のメンバ xとy');

% 構造体の配列
myKouzoutai(1).x = x;% myKouzoutaiという構造体配列の先頭(index=1)のメンバ x に変数xの値を格納
myKouzoutai(1).y = y1;% myKouzoutaiという構造体配列の先頭(index=1)のメンバ y に変数yの値を格納
myKouzoutai(2).x = x;% myKouzoutaiという構造体配列の(index=2)のメンバ x に変数xの値を格納
myKouzoutai(2).y = y2;% myKouzoutaiという構造体配列の(index=2)のメンバ y に変数y2の値を格納
myKouzoutai(3).x = x;% myKouzoutaiという構造体配列の(index=3)のメンバ x に変数xの値を格納
myKouzoutai(3).y = y3;% myKouzoutaiという構造体配列の(index=3)のメンバ y に変数y2の値を格納

figure,
myCol = [1,0,0; 0,1,0; 0,0,1;];% 色リスト
for i=1:3
    plot( myKouzoutai(i).x, myKouzoutai(i).y, 'Color', myCol(i,:) ); hold on;
end
legend('myKouzoutai(1)のxとｙ', '(2)', '(3)');
    