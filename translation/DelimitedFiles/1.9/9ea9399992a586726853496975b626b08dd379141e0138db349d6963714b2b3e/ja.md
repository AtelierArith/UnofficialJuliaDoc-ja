```
writedlm(f, A, delim='\t'; opts)
```

`A`（ベクトル、行列、または反復可能な行の反復可能コレクション）を、指定された区切り文字 `delim`（デフォルトはタブですが、任意の印刷可能なJuliaオブジェクト、通常は `Char` または `AbstractString`）を使用して、`f`（ファイル名の文字列または `IO` ストリーム）にテキストとして書き込みます。

例えば、同じ長さの2つのベクトル `x` と `y` は、`writedlm(f, [x y])` または `writedlm(f, zip(x, y))` のいずれかを使用して、タブ区切りのテキストの2列として `f` に書き込むことができます。

# 例

```jldoctest
julia> using DelimitedFiles

julia> x = [1; 2; 3; 4];

julia> y = [5; 6; 7; 8];

julia> open("delim_file.txt", "w") do io
           writedlm(io, [x y])
       end

julia> readdlm("delim_file.txt", '\t', Int, '\n')
4×2 Matrix{Int64}:
 1  5
 2  6
 3  7
 4  8

julia> rm("delim_file.txt")
```
