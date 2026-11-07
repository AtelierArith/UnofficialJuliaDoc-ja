```julia
pgenerate([::AbstractWorkerPool], f, c...) -> iterator
```

利用可能なワーカーとタスクを使って、`c`の各要素に対し、並列に`f`を適用します。

複数のコレクション引数を指定した場合は、`f`を要素ごとに適用します。

結果は、準備できた順に返されます。

`f`はすべてのワーカープロセスから利用できるようにする必要があります。詳しくは[Code Availability and Loading Packages](@ref code-availability)を参照してください。
