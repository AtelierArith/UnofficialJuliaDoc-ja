```julia
repeat(s::AbstractString, r::Integer)
```

文字列を`r`回繰り返します。これは`s^r`と記述できます。

[`^`](@ref :^(::Union{AbstractString, AbstractChar}, ::Integer))も参照してください。

# Examples

```jldoctest
julia> repeat("ha", 3)
"hahaha"
```
