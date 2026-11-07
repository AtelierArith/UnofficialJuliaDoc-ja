```julia
iseven(x::Number)::Bool
```

`x` が偶数（つまり、2で割り切れる整数）の場合は `true` を返し、それ以外の場合は `false` を返します。

!!! compat "Julia 1.7"
    `Integer` 以外の引数には、Julia 1.7 以降が必要です。


# Examples

```jldoctest
julia> iseven(9)
false

julia> iseven(10)
true
```
