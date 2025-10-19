```julia
seek(s, pos)
```

指定された位置にストリームをシークします。

# 例

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization.");

julia> seek(io, 5);

julia> read(io, Char)
'L': ASCII/Unicode U+004C (category Lu: Letter, uppercase)
```
