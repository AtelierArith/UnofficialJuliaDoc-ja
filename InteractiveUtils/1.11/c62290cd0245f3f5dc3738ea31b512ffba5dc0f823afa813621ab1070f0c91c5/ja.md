```
supertypes(T::Type)
```

`T`とそのすべてのスーパタイプのタプル`(T, ..., Any)`を返します。これは、[`supertype`](@ref)関数への連続した呼び出しによって決定され、`<:`の順序でリストされ、`Any`で終了します。

[`subtypes`](@ref)も参照してください。

# 例

```jldoctest
julia> supertypes(Int)
(Int64, Signed, Integer, Real, Number, Any)
```
