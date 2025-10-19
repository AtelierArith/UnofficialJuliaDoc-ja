```julia
copyuntil(out::IO, stream::IO, delim; keep::Bool = false)
copyuntil(out::IO, filename::AbstractString, delim; keep::Bool = false)
```

I/O `stream` またはファイルから、指定された区切り文字までの文字列を `out` ストリームにコピーし、`out` を返します。区切り文字は `UInt8`、`AbstractChar`、文字列、またはベクターであることができます。キーワード引数 `keep` は、結果に区切り文字が含まれるかどうかを制御します。テキストは UTF-8 でエンコードされていると仮定されます。

[`readuntil`](@ref) に似ていますが、`copyuntil` は文字列を割り当てることなく直接 `out` に書き込みます。（これは、例えば、事前に割り当てられた [`IOBuffer`](@ref) にデータを読み込むために使用できます。）

# 例

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> String(take!(copyuntil(IOBuffer(), "my_file.txt", 'L')))
"Julia"

julia> String(take!(copyuntil(IOBuffer(), "my_file.txt", '.', keep = true)))
"JuliaLang is a GitHub organization."

julia> rm("my_file.txt")
```
