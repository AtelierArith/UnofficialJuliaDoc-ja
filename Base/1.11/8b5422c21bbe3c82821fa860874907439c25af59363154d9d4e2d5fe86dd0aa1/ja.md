```
coalesce(x...)
```

引数の中で [`missing`](@ref) でない最初の値を返します。もしそのような値がなければ、`missing` を返します。

他にも [`skipmissing`](@ref)、[`something`](@ref)、[`@coalesce`](@ref) を参照してください。

# 例

```jldoctest
julia> coalesce(missing, 1)
1

julia> coalesce(1, missing)
1

julia> coalesce(nothing, 1)  # `nothing` を返します

julia> coalesce(missing, missing)
missing
```
