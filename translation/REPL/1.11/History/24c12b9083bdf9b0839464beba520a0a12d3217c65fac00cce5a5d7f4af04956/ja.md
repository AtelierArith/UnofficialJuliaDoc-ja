```julia
filterchunkrev!(out, candidates, spec, idx; maxtime, maxresults) -> Int
```

`candidates[1:idx]`を逆順に逐次フィルタリングします。

一致した要素を`out`に追加し、`maxtime`を超えるか、`maxresults`が収集されるまで処理した後、新しい再開インデックスを返します。
