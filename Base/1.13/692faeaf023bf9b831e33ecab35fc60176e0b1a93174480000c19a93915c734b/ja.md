```julia
ColumnSlices{M,AX,S}
```

[`Slices`](@ref)の特殊なケースで、[`eachcol`](@ref)によって構築される、行列の列スライスからなるベクトルです。

元の行列を取得するには、[`parent`](@ref)を使用できます。
