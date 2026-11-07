```julia
coalesce(x...)
```

引数のうち、[`missing`](@ref)と等しくない最初の値を返します。そのような値がない場合は、`missing`を返します。

関連項目: [`skipmissing`](@ref)、[`something`](@ref)、[`@coalesce`](@ref)。

# Examples

```jldoctest
julia> coalesce(missing, 1)
1

julia> coalesce(1, missing)
1

julia> coalesce(nothing, 1)  # returns `nothing`

julia> coalesce(missing, missing)
missing
```
