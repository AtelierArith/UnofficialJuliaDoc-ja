```julia
iszero(x)
```

`true` を返します。`x == zero(x)` の場合、`x` が配列であれば、`x` のすべての要素がゼロかどうかを判定します。

関連項目: [`isone`](@ref)、[`isinteger`](@ref)、[`isfinite`](@ref)、[`isnan`](@ref)。

# Examples

```jldoctest
julia> iszero(0.0)
true

julia> iszero([1, 9, 0])
false

julia> iszero([false, 0, 0])
true
```
