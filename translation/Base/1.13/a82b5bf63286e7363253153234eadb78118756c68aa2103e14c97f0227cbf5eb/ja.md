```julia
take!(b::IOBuffer)
```

`IOBuffer`の内容を配列として取得します。その後、`IOBuffer`は初期状態にリセットされます。

# Examples

```jldoctest
julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.", " It has many members.")
56

julia> String(take!(io))
"JuliaLang is a GitHub organization. It has many members."
```
