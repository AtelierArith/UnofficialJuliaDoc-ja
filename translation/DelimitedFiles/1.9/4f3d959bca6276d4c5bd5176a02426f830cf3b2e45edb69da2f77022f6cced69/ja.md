```julia
writedlm(f, A, delim='\t'; opts)
```

`A`（ベクトル、行列、または反復可能な行のコレクション）を、指定した区切り文字 `delim`（既定値はタブですが、印字可能な任意の Julia オブジェクトを指定でき、通常は `Char` または `AbstractString`）を使って、`f`（ファイル名を表す文字列、または `IO` ストリーム）にテキストとして書き込みます。

たとえば、同じ長さの2つのベクトル `x` と `y` は、タブ区切りテキストの2列として `f` に書き込めます。方法は `writedlm(f, [x y])` または `writedlm(f, zip(x, y))` です。

# Examples

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
