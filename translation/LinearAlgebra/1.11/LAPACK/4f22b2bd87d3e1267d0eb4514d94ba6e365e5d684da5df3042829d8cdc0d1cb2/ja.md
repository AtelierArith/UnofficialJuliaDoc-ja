```
pttrs!(D, E, B)
```

正定三対角行列 `A` に対して `A * X = B` を解きます。ここで、対角成分は `D`、非対角成分は `E` です。`A` の LDLt 因子分解を `pttrf!` を使用して計算した後、`B` は解 `X` で上書きされます。
