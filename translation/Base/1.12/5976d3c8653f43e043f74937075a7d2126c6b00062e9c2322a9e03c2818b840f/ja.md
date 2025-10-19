```julia
read(io::IO, T)
```

`io` から型 `T` の単一値を、標準的なバイナリ表現で読み取ります。

Julia はエンディアンを自動的に変換しないことに注意してください。この目的のためには [`ntoh`](@ref) または [`ltoh`](@ref) を使用してください。

```julia
read(io::IO, String)
```

`io` の全体を `String` として読み取ります（[`readchomp`](@ref) も参照）。

# 例

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> read(io, Char)
'J': ASCII/Unicode U+004A (category Lu: Letter, uppercase)

julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> read(io, String)
"JuliaLang is a GitHub organization"
```
