```julia
redisplay_preview(io::IO, oldstate::SelectorState, oldrows::Int, newstate::SelectorState, newrows::Int)
```

プレビュー領域（右側）を差分更新し、内容を枠で囲んで表示します。

ホバー中または収集済みの項目を枠内に表示します。
