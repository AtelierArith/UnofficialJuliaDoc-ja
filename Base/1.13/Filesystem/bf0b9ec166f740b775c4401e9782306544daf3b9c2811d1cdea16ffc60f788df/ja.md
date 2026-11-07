```julia
walkdir(dir = pwd(); topdown=true, follow_symlinks=false, onerror=throw)
```

ディレクトリのディレクトリツリーをたどるイテレータを返します。

このイテレータは、`(path, dirs, files)`を含むタプルを返します。反復のたびに、`path`はツリー内の次のディレクトリに変わります。その後、`dirs`と`files`は、現在の`path`ディレクトリ内のディレクトリとファイルを含むベクターになります。ディレクトリツリーは、トップダウンまたはボトムアップでたどれます。`walkdir`または`stat`で`IOError`が発生した場合、デフォルトではエラーが再スローされます。`onerror`キーワード引数で、独自のエラー処理関数を指定できます。`onerror`には、引数として`IOError`が渡されます。返されるイテレータは状態を保持するため、繰り返しアクセスすると、[`Iterators.Stateful`](@ref)のように、前回の続きから再開します。

関連項目: [`readdir`](@ref)。

!!! compat "Julia 1.12"
    Julia 1.12で、`pwd()`がデフォルトのディレクトリとして追加されました。


# Examples

```julia
for (path, dirs, files) in walkdir(".")
    println("Directories in $path")
    for dir in dirs
        println(joinpath(path, dir)) # path to directories
    end
    println("Files in $path")
    for file in files
        println(joinpath(path, file)) # path to files
    end
end
```

```jldoctest; setup = :(prevdir = pwd(); tmpdir = mktempdir(); cd(tmpdir)), teardown = :(cd(prevdir); rm(tmpdir, recursive=true))
julia> mkpath("my/test/dir");

julia> itr = walkdir("my");

julia> (path, dirs, files) = first(itr)
("my", ["test"], String[])

julia> (path, dirs, files) = first(itr)
("my/test", ["dir"], String[])

julia> (path, dirs, files) = first(itr)
("my/test/dir", String[], String[])
```
