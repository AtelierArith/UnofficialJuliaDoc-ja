```julia
copyuntil(out::IO, stream::IO, delim; keep::Bool = false)
copyuntil(out::IO, filename::AbstractString, delim; keep::Bool = false)
```

I/O `stream`またはファイルから、指定した区切り文字までの文字列を`out`ストリームにコピーし、`out`を返します。区切り文字には、`UInt8`、`AbstractChar`、文字列、またはベクトルを指定できます。キーワード引数`keep`は、区切り文字を結果に含めるかどうかを制御します。テキストはUTF-8でエンコードされているものとします。

[`readuntil`](@ref)と似ていますが、こちらは`String`を返します。一方、`copyuntil`は文字列を割り当てずに`out`へ直接書き込みます。（たとえば、事前に割り当てた[`IOBuffer`](@ref)にデータを読み込む場合に利用できます。）

# Examples

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> takestring!(copyuntil(IOBuffer(), "my_file.txt", 'L'))
"Julia"

julia> takestring!(copyuntil(IOBuffer(), "my_file.txt", '.', keep = true))
"JuliaLang is a GitHub organization."

julia> rm("my_file.txt")
```

!!! compat "Julia 1.11"
    `copyuntil`はJulia 1.11で導入されました。

