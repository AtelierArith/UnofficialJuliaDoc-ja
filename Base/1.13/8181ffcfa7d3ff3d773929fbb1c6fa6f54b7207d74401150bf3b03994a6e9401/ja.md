```julia
isreadonly(io)::Bool
```

ストリームが読み取り専用かどうかを判定します。

# Examples

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> isreadonly(io)
true

julia> io = IOBuffer();

julia> isreadonly(io)
false
```
