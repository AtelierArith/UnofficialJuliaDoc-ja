```julia
readchomp(x)
```

`x`の全体を文字列として読み込み、もしあれば末尾の改行を1つ削除します。`chomp(read(x, String))`と同等です。

# 例

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> readchomp("my_file.txt")
"JuliaLang is a GitHub organization.\nIt has many members."

julia> rm("my_file.txt");
```
