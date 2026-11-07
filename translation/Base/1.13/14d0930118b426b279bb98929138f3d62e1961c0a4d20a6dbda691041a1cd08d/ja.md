```julia
print([io::IO], xs...)
```

`io`（または`io`が指定されていない場合は、デフォルトの出力ストリームである[`stdout`](@ref)）に、正規化された（装飾のない）テキスト表現を書き込みます。`print`で使われる表現は、書式を最小限に抑え、Julia固有の詳細を避けるようにしています。

`print`は、`xs`内の各引数`x`について、2引数の`show(io, x)`を呼び出すため、ほとんどの型では`show`を定義するだけで十分です。型に独立した「プレーン」表現がある場合は、`print`を定義してください。たとえば、`show`は文字列を引用符付きで表示し、`print`は引用符なしで表示します。

[`println`](@ref)、[`string`](@ref)、[`printstyled`](@ref)も参照してください。

# Examples

```jldoctest
julia> print("Hello World!")
Hello World!
julia> io = IOBuffer();

julia> print(io, "Hello", ' ', :World!)

julia> takestring!(io)
"Hello World!"
```
