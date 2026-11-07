```julia
readchomp(x)
```

`x` を文字列として全体を読み込み、末尾に改行が1つあれば削除します。`chomp(read(x, String))` と同等です。

# Examples

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> readchomp("my_file.txt")
"JuliaLang is a GitHub organization.\nIt has many members."

julia> rm("my_file.txt");
```
