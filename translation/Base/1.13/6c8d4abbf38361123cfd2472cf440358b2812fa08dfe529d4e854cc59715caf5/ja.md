```julia
Pipe()
```

複数のプロセス間での IO 通信などに使う、未初期化の Pipe オブジェクトを構築します。

プロセスの起動時にこのオブジェクトを使用すると、パイプの適切な端が自動的に初期化されます。たとえば、プロセスパイプライン内の参照を簡単に取得するのに便利です。

```julia
julia> err = Pipe()

# After this `err` will be initialized and you may read `foo`'s
# stderr from the `err` pipe, or pass `err` to other pipelines.
julia> run(pipeline(pipeline(`foo`, stderr=err), `cat`), wait=false)

# Now destroy the write half of the pipe, so that the read half will get EOF
julia> closewrite(err)

julia> read(err, String)
"stderr messages"
```

[`Base.link_pipe!`](@ref) も参照してください。
