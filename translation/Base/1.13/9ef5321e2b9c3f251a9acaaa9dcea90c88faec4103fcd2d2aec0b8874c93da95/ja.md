```julia
countlines(io::IO; eol::AbstractChar = '\n')
countlines(filename::AbstractString; eol::AbstractChar = '\n')
```

`io` をストリームまたはファイルの末尾まで読み込み、行数を数えます。ファイルを指定するには、第1引数にファイル名を渡します。`'\n'` 以外の行末マーカーも、第2引数に渡すことで使用できます。`io` の最後の空でない行は、行末マーカーで終わっていなくても数えられるため、[`eachline`](@ref) と [`readlines`](@ref) が返す長さと一致します。

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
