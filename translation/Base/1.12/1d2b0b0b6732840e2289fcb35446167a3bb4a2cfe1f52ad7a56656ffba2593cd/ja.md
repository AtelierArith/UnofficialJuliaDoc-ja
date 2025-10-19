```julia
redirect_stdio(f; stdin=nothing, stderr=nothing, stdout=nothing)
```

`stdin`、`stderr`、`stdout` のサブセットをリダイレクトし、`f()` を呼び出して各ストリームを復元します。

各ストリームの可能な値は次のとおりです：

  * `nothing` はストリームをリダイレクトしないことを示します。
  * `path::AbstractString` はストリームを `path` のファイルにリダイレクトします。
  * `io` は `IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、または `devnull` です。

# 例

```julia-repl
julia> redirect_stdio(stdout="stdout.txt", stderr="stderr.txt") do
           print("hello stdout")
           print(stderr, "hello stderr")
       end

julia> read("stdout.txt", String)
"hello stdout"

julia> read("stderr.txt", String)
"hello stderr"
```

# エッジケース

`stdout` と `stderr` に同じ引数を渡すことが可能です：

```julia-repl
julia> redirect_stdio(stdout="log.txt", stderr="log.txt", stdin=devnull) do
    ...
end
```

ただし、同じファイルの2つの異なるディスクリプタを渡すことはサポートされていません。

```julia-repl
julia> io1 = open("same/path", "w")

julia> io2 = open("same/path", "w")

julia> redirect_stdio(f, stdout=io1, stderr=io2) # サポートされていません
```

また、`stdin` 引数は `stdout` または `stderr` と同じディスクリプタであってはなりません。

```julia-repl
julia> io = open(...)

julia> redirect_stdio(f, stdout=io, stdin=io) # サポートされていません
```

!!! compat "Julia 1.7"
    `redirect_stdio` は Julia 1.7 以降が必要です。

