```julia
^(s::Union{AbstractString,AbstractChar}, n::Integer) -> AbstractString
```

文字列または文字を `n` 回繰り返します。これは `repeat(s, n)` としても書くことができます。

参照: [`repeat`](@ref).

# 例

```jldoctest
julia> "Test "^3
"Test Test Test "
```
