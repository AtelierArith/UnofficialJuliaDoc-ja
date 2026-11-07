```julia
AbstractDict{K, V}
```

キーの型が`K`、値の型が`V`である、辞書のような型のスーパータイプです。[`Dict`](@ref)、[`IdDict`](@ref)などの型は、この型のサブタイプです。`AbstractDict{K, V}`は、`Pair{K, V}`のイテレーターである必要があります。
