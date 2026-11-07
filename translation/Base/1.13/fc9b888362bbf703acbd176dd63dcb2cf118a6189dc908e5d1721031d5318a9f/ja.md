```julia
Matrix{T} <: AbstractMatrix{T}
```

要素の型が`T`である2次元の密な配列。数学的な行列を表すためによく使われます。[`Array{T,2}`](@ref)の別名です。

行列の作成方法については、[`fill`](@ref)、[`zeros`](@ref)、[`undef`](@ref)、[`similar`](@ref)も参照してください。
