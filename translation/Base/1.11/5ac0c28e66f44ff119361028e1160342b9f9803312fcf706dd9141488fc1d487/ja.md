```
countlines(io::IO; eol::AbstractChar = '\n')
countlines(filename::AbstractString; eol::AbstractChar = '\n')
```

`io`のストリーム/ファイルの終わりまで読み取り、行数をカウントします。ファイルを指定するには、最初の引数としてファイル名を渡します。EOLマーカーは、第二引数として渡すことで`'\n'`以外のものもサポートされています。`io`の最後の非空行は、EOLで終わっていなくてもカウントされ、[`eachline`](@ref)および[`readlines`](@ref)によって返される長さと一致します。

`String`の行数をカウントするには、`countlines(IOBuffer(str))`を使用できます。

# 例

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization.\n");

julia> countlines(io)
1

julia> io = IOBuffer("JuliaLang is a GitHub organization.");

julia> countlines(io)
1

julia> eof(io) # 行をカウントするとファイルポインタが移動します
true

julia> io = IOBuffer("JuliaLang is a GitHub organization.");

julia> countlines(io, eol = '.')
1
```

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\n")
36

julia> countlines("my_file.txt")
1

julia> countlines("my_file.txt", eol = 'n')
4

julia> rm("my_file.txt")

```
