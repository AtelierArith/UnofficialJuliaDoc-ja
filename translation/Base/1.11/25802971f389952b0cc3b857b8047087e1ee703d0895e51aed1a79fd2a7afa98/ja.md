```
nonmissingtype(T::Type)
```

`T` が `Missing` を含む型のユニオンである場合、`Missing` を除いた新しい型を返します。

# 例

```jldoctest
julia> nonmissingtype(Union{Int64,Missing})
Int64

julia> nonmissingtype(Any)
Any
```

!!! compat "Julia 1.3"
    この関数は Julia 1.3 以降でエクスポートされています。

