```julia
countlines(io::IO; eol::AbstractChar = '\n')
countlines(filename::AbstractString; eol::AbstractChar = '\n')
```

`io` をストリームまたはファイルの末尾まで読み込み、行数を数えます。ファイルを指定するには、ファイル名を第1引数として渡します。`'\n'` 以外の行末（EOL）マーカーも、第2引数として渡すことで使用できます。`io` の最後の空でない行は、EOL で終わっていなくても数えられるため、[`eachline`](@ref) および [`readlines`](@ref) が返す長さと一致します。

`String` の行数を数えるには、`countlines(IOBuffer(str))` を使用できます。

# Examples

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization.\n");

julia> countlines(io)
1

julia> io = IOBuffer("JuliaLang is a GitHub organization.");

julia> countlines(io)
1

julia> eof(io) # counting lines moves the file pointer
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
