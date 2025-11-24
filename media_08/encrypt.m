clear; close all; clc;

img = uint8(zeros(50,50,3));
msg = "This is a message.\nCan you read this?";
[row, col, ~] = size(img);

for l=1:length(msg)
  letter = msg(l);
  letter_uint8 = uint8(letter);
  letter_bin = dec2bin(letter_uint8, 8);
  for i=1:8
    rep_bin = letter_bin(i);
    img_r = img(l, i, 1);
    img_r_bin = dec2bin(img_r, 8);
    img_r_bin(end) = rep_bin;
    img(l, i, 1) = bin2dec(img_r_bin);
  end
end

imshow(img);

for i=1:row
  str = "";
  for j=1:8
    r = img(i,j,1);
    r_bin = dec2bin(r);
    r_finalbit = r_bin(end);
    str = [str, r_finalbit];
  end
  fprintf("%c",char(bin2dec(str)));
end
fprintf("\n");
