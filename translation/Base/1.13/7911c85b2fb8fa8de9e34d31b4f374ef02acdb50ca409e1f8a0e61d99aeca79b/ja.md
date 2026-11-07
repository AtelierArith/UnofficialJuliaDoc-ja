```julia
readuntil(stream::IO, delim; keep::Bool = false)
readuntil(filename::AbstractString, delim; keep::Bool = false)
```

I/O `stream`またはファイルから、指定した区切り文字までの文字列を読み取ります。区切り文字には、`UInt8`、`AbstractChar`、文字列、またはベクトルを指定できます。キーワード引数`keep`は、区切り文字を結果に含めるかどうかを制御します。テキストはUTF-8でエンコードされているものとします。

`delim`が`AbstractChar`または文字列の場合は`String`を返し、それ以外の場合は`Vector{typeof(delim)}`を返します。別のストリーム（事前割り当て済みの[`IOBuffer`](@ref)も指定可能）に直接書き込む場合は、代わりに[`copyuntil`](@ref)を参照してください。

# Examples

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> readuntil("my_file.txt", 'L')
"Julia"

julia> readuntil("my_file.txt", '.', keep = true)
"JuliaLang is a GitHub organization."

julia> rm("my_file.txt")
```
