```julia
rank(S::SparseMatrixCSC{Tv,Ti}; [tol::Real]) -> Ti
```

QR 分解を計算して、`S` のランクを求めます。`tol` より小さい値はゼロとみなされます。SPQR のマニュアルを参照してください。
