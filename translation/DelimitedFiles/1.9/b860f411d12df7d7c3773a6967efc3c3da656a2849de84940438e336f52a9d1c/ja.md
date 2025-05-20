```
readdlm(source; options...)
```

列は1つ以上の空白で区切られていると仮定されます。行の終わりの区切り文字は`\n`と見なされます。すべてのデータが数値である場合、結果は数値配列になります。いくつかの要素が数値として解析できない場合、数値と文字列の異種配列が返されます。

# 例

```jldoctest
julia> using DelimitedFiles

julia> x = [1; 2; 3; 4];

julia> y = ["a"; "b"; "c"; "d"];

julia> open("delim_file.txt", "w") do io
           writedlm(io, [x y])
       end;

julia> readdlm("delim_file.txt")
4×2 Matrix{Any}:
 1  "a"
 2  "b"
 3  "c"
 4  "d"

julia> rm("delim_file.txt")
```
