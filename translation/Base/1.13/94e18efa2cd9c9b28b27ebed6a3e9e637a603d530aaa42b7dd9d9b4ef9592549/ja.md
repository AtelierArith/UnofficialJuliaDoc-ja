```julia
println([io::IO], xs...)
```

[`print`](@ref) を使って `xs` を `io` に出力し、その後に改行します。`io` が指定されていない場合は、デフォルトの出力ストリーム [`stdout`](@ref) に出力します。

色などを追加するには、[`printstyled`](@ref) も参照してください。

# Examples

```jldoctest
julia> println("Hello, world")
Hello, world

julia> io = IOBuffer();

julia> println(io, "Hello", ',', " world.")

julia> takestring!(io)
"Hello, world.\n"
```
