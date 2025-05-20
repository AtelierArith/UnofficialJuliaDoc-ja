```
mkpath(path::AbstractString; mode::Unsigned = 0o777)
```

`path`に必要なすべての中間ディレクトリを作成します。ディレクトリは、デフォルトで`0o777`の`mode`で作成され、現在のファイル作成マスクによって変更されます。[`mkdir`](@ref)とは異なり、`mkpath`は`path`（またはその一部）がすでに存在している場合にエラーを返しません。ただし、`path`（またはその一部）が既存のファイルを指している場合はエラーが発生します。`path`を返します。

`path`にファイル名が含まれている場合は、ファイル名を使用してディレクトリを作成しないように`mkpath(dirname(path))`を使用することをお勧めします。

# 例

```julia-repl
julia> cd(mktempdir())

julia> mkpath("my/test/dir") # 3つのディレクトリを作成
"my/test/dir"

julia> readdir()
1-element Array{String,1}:
 "my"

julia> cd("my")

julia> readdir()
1-element Array{String,1}:
 "test"

julia> readdir("test")
1-element Array{String,1}:
 "dir"

julia> mkpath("intermediate_dir/actually_a_directory.txt") # 2つのディレクトリを作成
"intermediate_dir/actually_a_directory.txt"

julia> isdir("intermediate_dir/actually_a_directory.txt")
true

```
