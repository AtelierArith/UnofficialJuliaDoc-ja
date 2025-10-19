```julia
walkdir(dir = pwd(); topdown=true, follow_symlinks=false, onerror=throw)
```

ディレクトリのツリーを歩くイテレータを返します。

イテレータは `(path, dirs, files)` を含むタプルを返します。各イテレーションで `path` はツリー内の次のディレクトリに変わり、`dirs` と `files` は現在の `path` ディレクトリ内のディレクトリとファイルを含むベクターになります。ディレクトリツリーは上から下へまたは下から上へとトラバースできます。`walkdir` または `stat` が `IOError` に遭遇した場合、デフォルトではエラーを再スローします。カスタムエラーハンドリング関数は `onerror` キーワード引数を通じて提供できます。`onerror` は引数として `IOError` を受け取ります。返されるイテレータは状態を持つため、繰り返しアクセスされると、各アクセスは前回の続きから再開されます。これは [`Iterators.Stateful`](@ref) のようです。

関連情報: [`readdir`](@ref).

!!! compat "Julia 1.12"
    デフォルトのディレクトリとして `pwd()` が追加されたのは Julia 1.12 です。


# 例

```julia
for (path, dirs, files) in walkdir(".")
    println("Directories in $path")
    for dir in dirs
        println(joinpath(path, dir)) # ディレクトリへのパス
    end
    println("Files in $path")
    for file in files
        println(joinpath(path, file)) # ファイルへのパス
    end
end
```

```julia-repl
julia> mkpath("my/test/dir");

julia> itr = walkdir("my");

julia> (path, dirs, files) = first(itr)
("my", ["test"], String[])

julia> (path, dirs, files) = first(itr)
("my/test", ["dir"], String[])

julia> (path, dirs, files) = first(itr)
("my/test/dir", String[], String[])
```
