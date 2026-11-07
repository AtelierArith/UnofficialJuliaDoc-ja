```julia
rank(S::SparseMatrixCSC{Tv,Ti}; [tol::Real]) -> Ti
```

QR分解を計算して、`S`のランクを求めます。`tol`より小さい値はゼロとみなされます。SPQRのマニュアルを参照してください。
