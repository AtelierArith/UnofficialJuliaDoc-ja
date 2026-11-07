```julia
read(io::IO, T)
```

`io`から、`T`型の値を1つ、標準的なバイナリ表現で読み込みます。

Juliaはエンディアンを自動変換しないことに注意してください。この目的には、[`ntoh`](@ref)または[`ltoh`](@ref)を使用してください。

```julia
read(io::IO, String)
```

`io`全体を、`String`として読み込みます（[`readchomp`](@ref)も参照）。

# Examples

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> read(io, Char)
'J': ASCII/Unicode U+004A (category Lu: Letter, uppercase)

julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> read(io, String)
"JuliaLang is a GitHub organization"
```
