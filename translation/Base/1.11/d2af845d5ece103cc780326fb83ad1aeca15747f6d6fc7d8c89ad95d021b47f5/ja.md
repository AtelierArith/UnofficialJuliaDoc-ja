```
Pipe()
```

未初期化の Pipe オブジェクトを構築します。これは、複数のプロセス間の IO 通信に特に適しています。

パイプの適切な端は、オブジェクトがプロセス生成に使用されると自動的に初期化されます。これは、プロセスパイプライン内で参照を簡単に取得するのに便利です。例えば：

```
julia> err = Pipe()

# この後、`err` は初期化され、`foo` の
# stderr を `err` パイプから読み取ることができるか、
# `err` を他のパイプラインに渡すことができます。
julia> run(pipeline(pipeline(`foo`, stderr=err), `cat`), wait=false)

# さて、パイプの書き込み半分を破棄して、
# 読み取り半分が EOF を受け取るようにします。
julia> closewrite(err)

julia> read(err, String)
"stderr messages"
```

[`Base.link_pipe!`](@ref) も参照してください。
