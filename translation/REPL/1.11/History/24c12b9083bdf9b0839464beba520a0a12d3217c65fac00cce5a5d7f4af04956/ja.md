```julia
filterchunkrev!(out, candidates, spec, idx; maxtime, maxresults) -> Int
```

`candidates[1:idx]` を逆順に逐次フィルタリングします。

一致した要素を `out` に追加します。`maxtime` を超えるか、`maxresults` 個を収集すると処理を終了し、新しい再開インデックスを返します。
