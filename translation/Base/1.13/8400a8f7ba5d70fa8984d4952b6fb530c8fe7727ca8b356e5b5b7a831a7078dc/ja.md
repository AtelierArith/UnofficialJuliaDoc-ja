```julia
AbstractRange{T} <: AbstractVector{T}
```

要素の型が `T` である線形範囲のスーパータイプです。[`UnitRange`](@ref)、[`LinRange`](@ref) などの型は、この型のサブタイプです。

すべてのサブタイプで [`step`](@ref) を定義する必要があります。したがって、[`LogRange`](@ref Base.LogRange) は `AbstractRange` のサブタイプではありません。
