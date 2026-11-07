```julia
^(s::Union{AbstractString,AbstractChar}, n::Integer)::AbstractString
```

文字列または文字を`n`回繰り返します。これは`repeat(s, n)`とも書けます。

[`repeat`](@ref)も参照してください。

# Examples

```jldoctest
julia> "Test "^3
"Test Test Test "
```
