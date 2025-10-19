```julia
Pipe()
```

初期化されていないPipeオブジェクトを構築します。これは、複数のプロセス間のIO通信に特に便利です。

パイプの適切な端は、オブジェクトがプロセスの生成に使用されると自動的に初期化されます。これは、プロセスパイプライン内で参照を簡単に取得するのに役立ちます。例えば：

```julia
julia> err = Pipe()

# この後、`err`は初期化され、`err`パイプから`foo`の
# stderrを読み取ることができるか、`err`を他のパイプラインに渡すことができます。
julia> run(pipeline(pipeline(`foo`, stderr=err), `cat`), wait=false)

# さて、パイプの書き込み半分を破棄して、読み取り半分がEOFを受け取るようにします。
julia> closewrite(err)

julia> read(err, String)
"stderr messages"
```

詳細は[`Base.link_pipe!`](@ref)を参照してください。
