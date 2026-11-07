```julia
repeat(c::AbstractChar, r::Integer)::String
```

文字を`r`回繰り返します。これは、[`c^r`](@ref :^(::Union{AbstractString, AbstractChar}, ::Integer))を呼び出すことでも同様に実現できます。

# Examples

```jldoctest
julia> repeat('A', 3)
"AAA"
```
