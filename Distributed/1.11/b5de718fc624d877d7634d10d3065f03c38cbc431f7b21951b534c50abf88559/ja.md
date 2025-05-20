```
pgenerate([::AbstractWorkerPool], f, c...) -> iterator
```

利用可能なワーカーとタスクを使用して、`c` の各要素に `f` を並行して適用します。

複数のコレクション引数がある場合、要素ごとに `f` を適用します。

結果は、利用可能になると順番に返されます。

`f` はすべてのワーカープロセスで利用可能でなければならないことに注意してください。詳細については、[Code Availability and Loading Packages](@ref code-availability)を参照してください。
