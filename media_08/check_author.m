clear; close all; clc;
img = cell(2,1);
img{1} = imread("C11_Odd_Img03.bmp");
img{2} = imread("C11_Even_Img01.bmp");

for h=1:2
  for i=1:10
    str = [];
    for j=1:8
      r = img{h}(i,j,1);
      r_bin = dec2bin(r);
      r_finalbit = r_bin(end);
      str = [str, r_finalbit];
    end
    fprintf("%c",char(bin2dec(str)));
  end
  fprintf("\n");
end

