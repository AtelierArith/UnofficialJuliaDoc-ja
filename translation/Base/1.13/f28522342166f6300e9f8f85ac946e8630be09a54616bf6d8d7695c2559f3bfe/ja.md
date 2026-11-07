```julia
copyline(out::IO, io::IO=stdin; keep::Bool=false)
copyline(out::IO, filename::AbstractString; keep::Bool=false)
```

I/O `stream`またはファイルから1行のテキストを読み取り、`out`ストリームにコピーして、`out`を返します。

ファイルから読み取る場合、テキストはUTF-8でエンコードされているものとします。入力行は、`'\n'`、`"\r\n"`、または入力ストリームの終端で区切られます。`keep`がfalse（デフォルト）の場合、返す前に行末の改行文字を取り除きます。`keep`がtrueの場合、改行文字も行の一部として返します。

[`readline`](@ref)と似ています。こちらは`String`を返します。一方、`copyline`は文字列を割り当てずに、`out`へ直接書き込みます。（たとえば、事前に割り当てた[`IOBuffer`](@ref)にデータを読み込む場合に利用できます。）

より一般的な区切り文字まで読み取る方法については、[`copyuntil`](@ref)も参照してください。

# Examples

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> takestring!(copyline(IOBuffer(), "my_file.txt"))
"JuliaLang is a GitHub organization."

julia> takestring!(copyline(IOBuffer(), "my_file.txt", keep=true))
"JuliaLang is a GitHub organization.\n"

julia> rm("my_file.txt")
```

!!! compat "Julia 1.11"
    `copyline`がJulia 1.11で導入されました。

