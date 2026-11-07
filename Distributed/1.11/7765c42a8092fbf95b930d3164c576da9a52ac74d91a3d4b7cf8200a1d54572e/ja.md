```julia
pgenerate([::AbstractWorkerPool], f, c...) -> iterator
```

利用可能なワーカーとタスクを使って、`c`の各要素に対して`f`を並列に適用します。

複数のコレクション引数を指定した場合は、`f`を要素ごとに適用します。

結果は、利用可能になった順に返されます。

`f`はすべてのワーカープロセスから利用できるようにする必要があります。詳しくは[Code Availability and Loading Packages](@ref code-availability)を参照してください。
