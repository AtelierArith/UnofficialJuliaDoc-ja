```
gglse!(A, c, B, d) -> (X,res)
```

方程式 `A * x = c` を解きます。ここで `x` は等式制約 `B * x = d` に従います。式 `||c - A*x||^2 = 0` を使用して解決します。`X` と残差の二乗和を返します。
