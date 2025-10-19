```julia
RowSlices{M,AX,S}
```

行列の行スライスのベクトルである[`Slices`](@ref)の特別なケースであり、[`eachrow`](@ref)によって構築されます。

[`parent`](@ref)を使用して、基になる行列を取得できます。
