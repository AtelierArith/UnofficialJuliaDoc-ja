```
AbstractRange{T} <: AbstractVector{T}
```

型 `T` の要素を持つ線形範囲のスーパタイプです。 [`UnitRange`](@ref)、[`LinRange`](@ref) およびその他の型はこのサブタイプです。

すべてのサブタイプは [`step`](@ref) を定義する必要があります。したがって、[`LogRange`](@ref Base.LogRange) は `AbstractRange` のサブタイプではありません。
