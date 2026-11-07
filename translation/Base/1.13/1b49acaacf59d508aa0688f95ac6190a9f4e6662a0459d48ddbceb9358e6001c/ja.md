```julia
redirect_stdio(f; stdin=nothing, stderr=nothing, stdout=nothing)
```

ストリーム `stdin`、`stderr`、`stdout` の一部をリダイレクトするには、`f()` を呼び出し、各ストリームを復元します。

各ストリームに指定できる値は次のとおりです。

  * `nothing`：ストリームをリダイレクトしません。
  * `path::AbstractString`：ストリームを `path` のファイルにリダイレクトします。
  * `io`：`IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、または `devnull`。

# Examples

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

# Edge cases

`stdout` と `stderr` に同じ引数を渡すことはできます。

```julia-repl
julia> redirect_stdio(stdout="log.txt", stderr="log.txt", stdin=devnull) do
    ...
end
```

ただし、同じファイルを指す異なる2つのディスクリプターを渡すことはサポートされていません。

```julia-repl
julia> io1 = open("same/path", "w")

julia> io2 = open("same/path", "w")

julia> redirect_stdio(f, stdout=io1, stderr=io2) # not supported
```

また、`stdin` 引数には、`stdout` または `stderr` と同じディスクリプターを指定できません。

```julia-repl
julia> io = open(...)

julia> redirect_stdio(f, stdout=io, stdin=io) # not supported
```

!!! compat "Julia 1.7"
    `redirect_stdio` には Julia 1.7 以降が必要です。

