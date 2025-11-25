clear; close all; clc;
csvs = cell(2,1);
csvs{1} = importdata("C11_Odd_Sum.xlsx");
csvs{2} = importdata("C11_Even_Sum.xlsx");

for h=1:2 %odd -> even
  data = csvs{h};
  [row, col] = size(data);
  select_rate = zeros(row, col);
  for i=1:row
      for j=1:col
        if i==j
            continue;
        end
      select_rate(i, j) = data(i, j)/(data(i, j) + data(j, i));
      end
  end

  % Z=norminv(select_rate);
  Z = -sqrt(2)*erfcinv(2*select_rate);

  means = zeros(row,1);
  for i=1:row
    means(i,1)=mean(Z(i,[1:i-1, i+1:end]));
  end

  ranking = [(0:row-1)', means]; % imgID, Z_mean
  ranking = sortrows(ranking, -2); % -は降順の意

  fprintf(" 順位\t imgID\t  Zの平均値\n");
  for i=1:row
    fprintf("  %d\t|   %d\t|  %.5f\n", i, ranking(i,1), ranking(i,2));
  end
  fprintf("\n");
end
