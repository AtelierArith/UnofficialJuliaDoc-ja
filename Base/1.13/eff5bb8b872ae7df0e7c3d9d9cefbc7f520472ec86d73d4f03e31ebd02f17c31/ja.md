```julia
readline(io::IO=stdin; keep::Bool=false)
readline(filename::AbstractString; keep::Bool=false)
```

指定された I/O ストリームまたはファイルからテキストを1行読み取ります（デフォルトは `stdin`）。ファイルから読み取る場合、テキストは UTF-8 でエンコードされているものとします。入力の各行は、`'\n'`、`"\r\n"`、または入力ストリームの終端で区切られます。`keep` が false（デフォルト）の場合、返す前に行末の改行文字を取り除きます。`keep` が true の場合、改行文字も行の一部として返します。

`String` を返します。別のストリーム（事前に確保された [`IOBuffer`](@ref) など）にその場で書き込む場合は、[`copyline`](@ref) も参照してください。

より一般的な区切り文字まで読み取る方法については、[`readuntil`](@ref) も参照してください。

# Examples

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> readline("my_file.txt")
"JuliaLang is a GitHub organization."

julia> readline("my_file.txt", keep=true)
"JuliaLang is a GitHub organization.\n"

julia> rm("my_file.txt")
```

```julia-repl
julia> print("Enter your name: ")
Enter your name:

julia> your_name = readline()
Logan
"Logan"
```
