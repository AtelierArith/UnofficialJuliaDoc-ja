```julia
AbstractUnitRange{T} <: OrdinalRange{T, T}
```

要素の型が`T`で、ステップ幅が[`oneunit(T)`](@ref)の範囲のスーパータイプです。[`UnitRange`](@ref)などの型は、この型のサブタイプです。
