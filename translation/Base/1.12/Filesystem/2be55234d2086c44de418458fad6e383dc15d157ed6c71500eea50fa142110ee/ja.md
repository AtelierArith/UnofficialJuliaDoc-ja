```julia
mv(src::AbstractString, dst::AbstractString; force::Bool=false)
```

`src`から`dst`にファイル、リンク、またはディレクトリを移動します。`force=true`は、最初に既存の`dst`を削除します。`dst`を返します。

# 例

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
    `mv`関数は`mv` Unixコマンドとは異なります。`mv`関数はデフォルトで`dst`が存在する場合にエラーを返しますが、コマンドはデフォルトで既存の`dst`ファイルを削除します。また、`mv`関数は常に`dst`がファイルであると仮定して動作しますが、コマンドは`dst`がディレクトリかファイルかによって異なる動作をします。`dst`がディレクトリのときに`force=true`を使用すると、`dst`ディレクトリ内のすべての内容が失われ、`dst`は`src`の内容を持つファイルになります。

