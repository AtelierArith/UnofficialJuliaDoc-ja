```julia
RowSlices{M,AX,S}
```

[`Slices`](@ref)の特殊なケースで、[`eachrow`](@ref)によって構築される、行列の行スライスのベクトルです。

基になる行列を取得するには、[`parent`](@ref)を使用できます。
