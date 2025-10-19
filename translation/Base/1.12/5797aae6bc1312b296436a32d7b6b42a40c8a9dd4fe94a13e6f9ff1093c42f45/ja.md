```julia
readline(io::IO=stdin; keep::Bool=false)
readline(filename::AbstractString; keep::Bool=false)
```

指定されたI/Oストリームまたはファイルから1行のテキストを読み取ります（デフォルトは`stdin`）。ファイルから読み取る場合、テキストはUTF-8でエンコードされていると仮定されます。入力の行は`'\n'`または`"\r\n"`または入力ストリームの終わりで終了します。`keep`がfalse（デフォルトではそうです）の場合、これらの末尾の改行文字は返される前に行から削除されます。`keep`がtrueの場合、それらは行の一部として返されます。

`String`を返します。別のストリームにインプレースで書き込むためには、[`copyline`](@ref)も参照してください（これは事前に割り当てられた[`IOBuffer`](@ref)である可能性があります）。

より一般的な区切り文字まで読み取るためには、[`readuntil`](@ref)も参照してください。

# 例

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
