```julia
isodd(x::Number)::Bool
```

`x` が奇数（つまり、2で割り切れない整数）の場合は `true` を返し、それ以外の場合は `false` を返します。

!!! compat "Julia 1.7"
    `Integer` 以外の引数には、Julia 1.7 以降が必要です。


# Examples

```jldoctest
julia> isodd(9)
true

julia> isodd(10)
false
```
