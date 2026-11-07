```julia
exp2(x)
```

`x` の 2 を底とする指数関数を計算します。つまり、``2^x`` です。

関連項目: [`ldexp`](@ref)、[`<<`](@ref)。

# Examples

```jldoctest
julia> exp2(5)
32.0

julia> 2^5
32

julia> exp2(63) > typemax(Int)
true
```
