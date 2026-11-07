```julia
run_display!((; term,pstate), events::Channel{Symbol}, hist::Vector{HistEntry})
```

確定または中止されるまで、表示イベントループを実行します。

ナビゲーション、編集、保存、中止の各イベントを監視し、履歴を逐次再フィルタリングして、`redisplay_all`を使って再描画します。
