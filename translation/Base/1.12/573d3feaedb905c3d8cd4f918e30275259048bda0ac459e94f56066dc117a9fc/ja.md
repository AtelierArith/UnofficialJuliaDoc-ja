```julia
Matrix{T} <: AbstractMatrix{T}
```

要素の型が `T` の二次元密な配列で、数学的な行列を表すためにしばしば使用されます。 [`Array{T,2}`](@ref) のエイリアスです。

行列を作成するための [`fill`](@ref)、[`zeros`](@ref)、[`undef`](@ref)、および [`similar`](@ref) も参照してください。
