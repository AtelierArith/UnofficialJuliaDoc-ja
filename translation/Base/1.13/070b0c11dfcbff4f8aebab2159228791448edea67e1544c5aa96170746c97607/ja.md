```julia
Base.unaliascopy(A)
```

別の配列が変更されても一貫した意味を保てるよう、その配列に対する `A` [`Base.mightalias`](@ref) を行う際に、`A` の予防的なコピーを作成します。

エイリアスが発生しない、より一般的なケースで最適なパフォーマンスを維持するため、これは `A` と同じ型のオブジェクトを返す必要があります。デフォルトでは、`unaliascopy(A::AbstractArray)` は [`copy(A)`](@ref) を使用しようとしますが、`copy(A)` が `typeof(A)` ではない場合、配列側で `Base.unaliascopy(A)` の独自実装を用意する必要があります。
