```julia
AsyncGenerator(f, c...; ntasks=0, batch_size=nothing) -> iterator
```

`c`の各要素に対して、最大`ntasks`個の非同期タスクを使って`f`を適用します。

キーワード引数`ntasks`と`batch_size`の動作は、[`asyncmap`](@ref)と同じです。`batch_size`を指定する場合、`f`には、引数タプルの配列を処理する関数を指定する必要があります。

!!! note
    `collect(AsyncGenerator(f, c...; ntasks=1))`は`map(f, c...)`と同等です。

