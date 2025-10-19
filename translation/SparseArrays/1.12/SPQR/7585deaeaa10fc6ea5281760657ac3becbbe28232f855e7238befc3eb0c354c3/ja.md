```julia
rank(S::SparseMatrixCSC{Tv,Ti}; [tol::Real]) -> Ti
```

`S`のランクをQR因子分解を計算することによって計算します。`tol`より小さい値はゼロと見なされます。SPQRのマニュアルを参照してください。
