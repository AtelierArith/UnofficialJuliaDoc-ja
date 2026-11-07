```julia
readdlm(source; options...)
```

列は1つ以上の空白文字で区切られているものとします。行末の区切り文字には`\n`が使用されます。すべてのデータが数値の場合、結果は数値配列になります。数値として解析できない要素がある場合は、数値と文字列を含む異種配列が返されます。

# Examples

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
