```julia
AsyncCollector(f, results, c...; ntasks=0, batch_size=nothing) -> iterator
```

`c` の各要素に対して非同期に `f` を適用し、その出力を `results` に収集するイテレータを返します。

キーワード引数 `ntasks` と `batch_size` の動作は、[`asyncmap`](@ref) と同じです。`batch_size` を指定する場合、`f` は引数タプルの配列を処理する関数でなければなりません。

!!! note
    `iterate(::AsyncCollector, state) -> (nothing, state)`。`iterate` が正常に返ると、入力コレクションの次の要素の非同期処理が開始されたことを示します。空きワーカータスクが利用可能になるまでブロックします。


!!! note
    `for _ in AsyncCollector(f, results, c...; ntasks=1) end` は `map!(f, results, c...)` と同等です。

