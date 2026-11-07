```julia
supertypes(T::Type)
```

`(T, ..., Any)` を返します。これは、`T` と、そのすべてのスーパータイプを、[`supertype`](@ref) 関数を順次呼び出して求めたものです。`<:` の順に並び、`Any` で終わります。

[`subtypes`](@ref) も参照してください。

# Examples

```jldoctest
julia> supertypes(Int)
(Int64, Signed, Integer, Real, Number, Any)
```
