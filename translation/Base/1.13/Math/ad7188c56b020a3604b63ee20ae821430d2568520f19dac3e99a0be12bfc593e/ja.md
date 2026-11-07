```julia
exp(x)
```

`x` の自然底の指数関数を計算します。つまり、``ℯ^x`` です。

関連項目: [`exp2`](@ref)、[`exp10`](@ref)、[`cis`](@ref)。

# Examples

```jldoctest
julia> exp(1.0)
2.718281828459045

julia> exp(im * pi) ≈ cis(pi)
true
```
