```
isodd(x::Number) -> Bool
```

`x` が奇数整数（すなわち、2で割り切れない整数）の場合は `true` を返し、それ以外の場合は `false` を返します。

!!! compat "Julia 1.7"
    非 `Integer` 引数は Julia 1.7 以降が必要です。


# 例

```jldoctest
julia> isodd(9)
true

julia> isodd(10)
false
```
