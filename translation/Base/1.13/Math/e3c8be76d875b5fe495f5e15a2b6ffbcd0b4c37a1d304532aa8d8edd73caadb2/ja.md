```julia
exp2(x)
```

`x` の底 2 の指数関数を計算します。つまり、``2^x`` です。

[`ldexp`](@ref)、[`<<`](@ref) も参照してください。

# Examples

```jldoctest
julia> exp2(5)
32.0

julia> 2^5
32

julia> exp2(63) > typemax(Int)
true
```
