clear; close all; clc;

% 1変数の場合① --------------------------------------------------------------
figure,
x = -3:0.01:3;
sig = 1;% 標準偏差
mu = 0;% 平均
val = (1/sqrt(2*pi*sig^2))*exp( -((x-mu).^2)/(2*sig*sig) );% -> 積と要素積の話

plot(x, val, 'b-');
xlabel('x'); ylabel('y'); title('ガウス分布');
ylim([0, 1]);

% ----- 積と要素積の話
% 「.^」や「./」は要素ごとの積や商を求めるときに使う，ベクトルや配列のサイズは同じである必要がある
% sig や mu はスカラーで，スカラーとベクトル（配列）の演算は，全要素に作用する
% 違いを見極めるのが大事（※型とサイズを逐一確認するのがMatlab上達の極意！）


% 1変数の場合② --------------------------------------------------------------



figure,
sig_list = [1, 2, 3, 4];
mu = 0;
myLegend = [];% 凡例の項目名
for i=1:length(sig_list) 
    sig = sig_list(i);%
    x = -3*sig:0.01:3*sig;
    val = (1/sqrt(2*pi*sig^2))*exp( -((x-mu).^2)/(2*sig*sig) );
    
    myColor = hsv2rgb([(i-1)/length(sig_list), 1, 1]);
    plot(x, val, '-', 'Color', myColor); hold on;
    myLegend{i} = ['\mu = ' num2str(mu) '0, \sigma = ' num2str(sig)];
end
xlabel('x'); ylabel('y'); title('ガウス分布 (σを変えると)');
legend(myLegend, 'Location', 'NorthEast');
ylim([0, 0.5]);

figure,
mu_list = -2:2;
myLegend = [];% 凡例の項目名
sig = 1;
for i=1:length(mu_list) 
    mu = mu_list(i);%
    x = -3*sig:0.01:3*sig;
    val = (1/sqrt(2*pi*sig^2))*exp( -((x-mu).^2)/(2*sig*sig) );
    
    myColor = hsv2rgb([(i-1)/length(mu_list), 1, 1]);
    plot(x, val, '-', 'Color', myColor); hold on;
    myLegend{i} = ['\mu = ' num2str(mu) '0, \sigma = ' num2str(sig)];
end
xlabel('x'); ylabel('y'); title('ガウス分布 (μを変えると)');
legend(myLegend, 'Location', 'NorthEast');
ylim([0, 0.5]);
