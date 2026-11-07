```julia
mkpath(path::AbstractString; mode::Unsigned = 0o777)
```

必要に応じて、`path`内のすべての中間ディレクトリを作成します。ディレクトリは`mode`の権限で作成されます。この権限の既定値は`0o777`で、現在のファイル作成マスクによって変更されます。[`mkdir`](@ref)とは異なり、`mkpath`は、`path`（またはその一部）がすでに存在していてもエラーになりません。ただし、`path`（またはその一部）が既存のファイルを指している場合は、エラーが発生します。`path`を返します。

`path`にファイル名が含まれている場合は、そのファイル名を使ってディレクトリを作成しないよう、`mkpath(dirname(path))`を使うとよいでしょう。

# Examples

```julia-repl
julia> cd(mktempdir())

julia> mkpath("my/test/dir") # creates three directories
"my/test/dir"

julia> readdir()
1-element Vector{String}:
 "my"

julia> cd("my")

julia> readdir()
1-element Vector{String}:
 "test"

julia> readdir("test")
1-element Vector{String}:
 "dir"

julia> mkpath("intermediate_dir/actually_a_directory.txt") # creates two directories
"intermediate_dir/actually_a_directory.txt"

julia> isdir("intermediate_dir/actually_a_directory.txt")
true

julia> mkpath("my/test/dir/") # returns the original `path`
"my/test/dir/"
```
