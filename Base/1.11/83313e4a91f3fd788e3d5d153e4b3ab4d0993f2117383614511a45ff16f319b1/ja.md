```
println([io::IO], xs...)
```

`xs`を`io`に改行付きで印刷します（[`print`](@ref)を使用）。`io`が指定されていない場合は、デフォルトの出力ストリーム[`stdout`](@ref)に印刷します。

色などを追加するには、[`printstyled`](@ref)も参照してください。

# 例

```jldoctest
julia> println("Hello, world")
Hello, world

julia> io = IOBuffer();

julia> println(io, "Hello", ',', " world.")

julia> String(take!(io))
"Hello, world.\n"
```
