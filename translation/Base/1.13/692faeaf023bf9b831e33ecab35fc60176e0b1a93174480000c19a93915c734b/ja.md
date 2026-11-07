```julia
ColumnSlices{M,AX,S}
```

行列の列スライスからなるベクトルである、[`Slices`](@ref)の特殊なケースです。[`eachcol`](@ref)で構築できます。

元の行列を取得するには、[`parent`](@ref)を使用できます。
