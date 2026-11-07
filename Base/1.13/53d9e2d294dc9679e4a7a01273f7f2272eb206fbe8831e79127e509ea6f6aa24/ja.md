```julia
bytesavailable(io)
```

このストリームまたはバッファから読み取る際にブロックされるまでに、読み取り可能なバイト数を返します。

# Examples

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> bytesavailable(io)
34
```
