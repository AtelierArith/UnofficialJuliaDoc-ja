```
readlines(io::IO=stdin; keep::Bool=false)
readlines(filename::AbstractString; keep::Bool=false)
```

I/O ストリームまたはファイルのすべての行を文字列のベクターとして読み取ります。動作は、同じ引数で [`readline`](@ref) を繰り返し読み取った結果を保存し、その結果の行を文字列のベクターとして保存することと同等です。すべての行を一度に読み取ることなく、行を反復処理するには [`eachline`](@ref) も参照してください。

# 例

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> readlines("my_file.txt")
2-element Vector{String}:
 "JuliaLang is a GitHub organization."
 "It has many members."

julia> readlines("my_file.txt", keep=true)
2-element Vector{String}:
 "JuliaLang is a GitHub organization.\n"
 "It has many members.\n"

julia> rm("my_file.txt")
```
