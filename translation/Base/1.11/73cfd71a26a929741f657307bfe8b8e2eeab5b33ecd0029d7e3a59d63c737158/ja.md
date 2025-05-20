```
repeat(c::AbstractChar, r::Integer) -> String
```

文字を `r` 回繰り返します。これは、[`c^r`](@ref :^(::Union{AbstractString, AbstractChar}, ::Integer)) を呼び出すことによって同等に達成できます。

# 例

```jldoctest
julia> repeat('A', 3)
"AAA"
```
