import pandas as pd
import numpy as np
from scipy.stats import norm

# ------------ CSVの読み込み ------------
df = pd.read_csv("C11_Even_Sum.csv", header=None)

n = df.shape[0]
items = [f"I{i+1}" for i in range(n)]
df.index = items
df.columns = items

# ------------ Thurstone Case V 関数 ------------
def thurston_caseV(df):
    items = df.columns
    n = len(items)

    # 勝率 p_ij の計算
    p = np.zeros((n, n))
    for i in range(n):
        for j in range(n):
            if i == j:
                p[i, j] = np.nan
                continue
            win_ij = df.iloc[i, j]
            win_ji = df.iloc[j, i]
            p[i, j] = win_ij / (win_ij + win_ji)

    # 極端な値（0,1）の補正
    eps = 1e-5
    p = np.clip(p, eps, 1 - eps)

    # Z行列
    Z = norm.ppf(p)

    # 尺度値は行平均（Case V）
    scale = np.nanmean(Z, axis=1)

    return pd.DataFrame(Z, index=items, columns=items), pd.Series(scale, index=items)

# ------------ 実行 ------------
Z_matrix, scale = thurston_caseV(df)

print("=== 心理尺度値（大きいほど上位） ===")
print(scale.sort_values(ascending=False))

print("\n=== ランク（1位が最上位） ===")
rank = scale.rank(method="min", ascending=False).astype(int)
print(rank.sort_values())
