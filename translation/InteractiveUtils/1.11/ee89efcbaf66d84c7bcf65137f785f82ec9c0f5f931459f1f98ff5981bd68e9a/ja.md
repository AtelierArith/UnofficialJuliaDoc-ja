```julia
supertypes(T::Type)
```

`T`と、そのすべてのスーパータイプをタプル`(T, ..., Any)`として返します。スーパータイプは、[`supertype`](@ref)関数を順に呼び出して求め、`<:`の順に並べ、`Any`で終端します。

[`subtypes`](@ref)を参照してください。

# Examples

```jldoctest
julia> supertypes(Int)
(Int64, Signed, Integer, Real, Number, Any)
```
