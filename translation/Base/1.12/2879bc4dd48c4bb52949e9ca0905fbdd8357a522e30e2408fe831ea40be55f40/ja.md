```julia
isreadonly(io) -> Bool
```

ストリームが読み取り専用かどうかを判断します。

# 例

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> isreadonly(io)
true

julia> io = IOBuffer();

julia> isreadonly(io)
false
```
