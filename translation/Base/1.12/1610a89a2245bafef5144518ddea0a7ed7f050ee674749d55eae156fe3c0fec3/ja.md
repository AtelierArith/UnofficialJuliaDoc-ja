```julia
argmax(f, domain)
```

`f(x)` が最大化される `domain` からの値 `x` を返します。`f(x)` の最大値が複数ある場合は、最初のものが見つかります。

`domain` は空でない反復可能なものでなければなりません。

値は `isless` で比較されます。

!!! compat "Julia 1.7"
    このメソッドは Julia 1.7 以降が必要です。


関連情報として [`argmin`](@ref)、[`findmax`](@ref) を参照してください。

# 例

```jldoctest
julia> argmax(abs, -10:5)
-10

julia> argmax(cos, 0:π/2:2π)
0.0
```
