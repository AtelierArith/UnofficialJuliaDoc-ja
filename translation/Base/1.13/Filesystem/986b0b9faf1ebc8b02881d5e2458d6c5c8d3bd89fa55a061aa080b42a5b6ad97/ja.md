```julia
mv(src::AbstractString, dst::AbstractString; force::Bool=false)
```

ファイル、リンク、またはディレクトリを`src`から`dst`へ移動します。`force=true`は、既存の`dst`を先に削除します。`dst`を返します。

# Examples

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> write("hello.txt", "world");

julia> mv("hello.txt", "goodbye.txt")
"goodbye.txt"

julia> "hello.txt" in readdir()
false

julia> readline("goodbye.txt")
"world"

julia> write("hello.txt", "world2");

julia> mv("hello.txt", "goodbye.txt")
ERROR: ArgumentError: 'goodbye.txt' exists. `force=true` is required to remove 'goodbye.txt' before moving.
Stacktrace:
 [1] #checkfor_mv_cp_cptree#10(::Bool, ::Function, ::String, ::String, ::String) at ./file.jl:293
[...]

julia> mv("hello.txt", "goodbye.txt", force=true)
"goodbye.txt"

julia> rm("goodbye.txt");

```

!!! note
    `mv`関数は、Unixコマンドの`mv`とは異なります。`mv`関数は、`dst`が存在するとデフォルトでエラーになります。一方、このコマンドは既存の`dst`ファイルをデフォルトで削除します。また、`mv`関数は常に`dst`をファイルとして扱いますが、このコマンドは`dst`がディレクトリかファイルかによって動作が異なります。`dst`がディレクトリの場合に`force=true`を使うと、`dst`ディレクトリ内のすべての内容が失われ、代わりに`dst`は`src`の内容を持つファイルになります。

