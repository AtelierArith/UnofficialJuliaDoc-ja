```julia
AsyncGenerator(f, c...; ntasks=0, batch_size=nothing) -> iterator
```

`f`を`c`の各要素に適用します。非同期タスクは最大`ntasks`個まで使用します。

キーワード引数`ntasks`と`batch_size`の動作は、[`asyncmap`](@ref)と同じです。`batch_size`を指定する場合、`f`は、引数タプルの配列を処理する関数でなければなりません。

!!! note
    `collect(AsyncGenerator(f, c...; ntasks=1))`は`map(f, c...)`と同等です。

