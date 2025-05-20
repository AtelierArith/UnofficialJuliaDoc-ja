```
copyline(out::IO, io::IO=stdin; keep::Bool=false)
copyline(out::IO, filename::AbstractString; keep::Bool=false)
```

I/O `ストリーム` またはファイルから `out` ストリームにテキストの1行をコピーし、`out` を返します。

ファイルから読み取る場合、テキストはUTF-8でエンコードされていると仮定されます。入力の行は `'\n'` または `"\r\n"` または入力ストリームの終わりで終了します。`keep` が false の場合（デフォルトではそうです）、これらの末尾の改行文字は返される前に行から削除されます。`keep` が true の場合、それらは行の一部として返されます。

[`readline`](@ref) に似ていますが、`String` を返すのに対し、`copyline` は文字列を割り当てることなく直接 `out` に書き込みます。（これは、例えば、事前に割り当てられた [`IOBuffer`](@ref) にデータを読み込むために使用できます。）

より一般的な区切り文字まで読み取るための [`copyuntil`](@ref) も参照してください。

# 例

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> String(take!(copyline(IOBuffer(), "my_file.txt")))
"JuliaLang is a GitHub organization."

julia> String(take!(copyline(IOBuffer(), "my_file.txt", keep=true)))
"JuliaLang is a GitHub organization.\n"

julia> rm("my_file.txt")
```
