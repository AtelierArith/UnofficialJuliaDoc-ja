```julia
redisplay_candidates(io::IO, oldstate::SelectorState, oldrows::Int, newstate::SelectorState, newrows::Int)
```

2つの状態間で候補リストペインの差分を取り、再描画します。

変更された行（項目のテキスト、選択状態、ホバー状態、幅）のみを再出力し、変更されていない行はそのまま残します。
