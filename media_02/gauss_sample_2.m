clear; close all; clc;

% 2変数の場合① --------------------------------------------------------------
sig = 2;

[x, y] = meshgrid(-3*sig:3*sig, -3*sig:3*sig);

val = exp( - ((x.^2)+(y.^2))/(2*sig^2)  );% exp()の前に係数を付けることもあるがここでは省略

figure,
subplot(1,2,1);
imagesc( val ); axis equal;
xlabel('x'); ylabel('y');


subplot(1,2,2);
mesh(x, y,  val );
xlabel('x'); ylabel('y'); zlabel('Z');
% xlim([-3, 3]); ylim([-3, 3])