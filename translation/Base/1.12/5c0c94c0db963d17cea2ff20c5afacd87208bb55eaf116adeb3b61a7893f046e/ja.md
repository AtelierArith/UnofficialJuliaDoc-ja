```julia
iseven(x::Number) -> Bool
```

`x` が偶数整数（すなわち、2で割り切れる整数）であれば `true` を返し、それ以外の場合は `false` を返します。

!!! compat "Julia 1.7"
    非 `Integer` 引数は Julia 1.7 以降が必要です。


# 例

```jldoctest
julia> iseven(9)
false

julia> iseven(10)
true
```
