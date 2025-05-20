```
walkdir(dir; topdown=true, follow_symlinks=false, onerror=throw)
```

ディレクトリのツリーを歩くイテレータを返します。イテレータは `(rootpath, dirs, files)` を含むタプルを返します。ディレクトリツリーは上から下へまたは下から上へとトラバースできます。`walkdir` または `stat` が `IOError` に遭遇した場合、デフォルトではエラーを再スローします。カスタムエラーハンドリング関数は `onerror` キーワード引数を通じて提供できます。`onerror` は `IOError` を引数として呼び出されます。

参照: [`readdir`](@ref).

# 例

```julia
for (root, dirs, files) in walkdir(".")
    println("Directories in $root")
    for dir in dirs
        println(joinpath(root, dir)) # ディレクトリへのパス
    end
    println("Files in $root")
    for file in files
        println(joinpath(root, file)) # ファイルへのパス
    end
end
```

```julia-repl
julia> mkpath("my/test/dir");

julia> itr = walkdir("my");

julia> (root, dirs, files) = first(itr)
("my", ["test"], String[])

julia> (root, dirs, files) = first(itr)
("my/test", ["dir"], String[])

julia> (root, dirs, files) = first(itr)
("my/test/dir", String[], String[])
```
