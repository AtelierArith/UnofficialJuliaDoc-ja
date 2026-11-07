```julia
println([io::IO], xs...)
```

`io` の後に改行を付けて、`xs` を [`print`](@ref) を使って出力します。`io` が指定されていない場合は、デフォルトの出力ストリーム [`stdout`](@ref) に出力します。

色などを追加する方法については、[`printstyled`](@ref) も参照してください。

# Examples

```jldoctest
julia> println("Hello, world")
Hello, world

julia> io = IOBuffer();

julia> println(io, "Hello", ',', " world.")

julia> takestring!(io)
"Hello, world.\n"
```
