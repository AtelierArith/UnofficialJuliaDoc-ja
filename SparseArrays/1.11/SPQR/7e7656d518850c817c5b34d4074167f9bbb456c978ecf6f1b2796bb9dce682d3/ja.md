```
rank(S::SparseMatrixCSC{Tv,Ti}; [tol::Real]) -> Ti
```

行列 `S` のランクを QR 分解を用いて計算します。`tol` より小さい値はゼロと見なされます。SPQR のマニュアルを参照してください。
