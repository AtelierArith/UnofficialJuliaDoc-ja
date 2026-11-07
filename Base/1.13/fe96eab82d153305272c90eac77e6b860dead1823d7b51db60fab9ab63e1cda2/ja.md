```julia
readlines(io::IO=stdin; keep::Bool=false)
readlines(filename::AbstractString; keep::Bool=false)
```

I/Oストリームまたはファイルのすべての行を、文字列のベクトルとして読み込みます。同じ引数で[`readline`](@ref)を繰り返し呼び出し、その結果を文字列のベクトルとして保存するのと同等の動作です。すべての行を一度に読み込まずに反復処理する方法については、[`eachline`](@ref)も参照してください。

# Examples

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
