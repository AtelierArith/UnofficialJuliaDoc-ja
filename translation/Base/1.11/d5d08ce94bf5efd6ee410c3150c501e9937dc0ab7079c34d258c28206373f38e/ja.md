```
iszero(x)
```

`x == zero(x)` の場合は `true` を返します。`x` が配列の場合、これは `x` のすべての要素がゼロであるかどうかをチェックします。

関連項目: [`isone`](@ref), [`isinteger`](@ref), [`isfinite`](@ref), [`isnan`](@ref)。

# 例

```jldoctest
julia> iszero(0.0)
true

julia> iszero([1, 9, 0])
false

julia> iszero([false, 0, 0])
true
```
