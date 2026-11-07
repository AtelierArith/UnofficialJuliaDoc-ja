```julia
hoveridx(state::SelectorState) -> Int
```

ホバー対象の `candidates` または `gathered` に対する符号付きインデックスを計算します。

正の値は `candidates`、負の値は `gathered` をインデックスします。0 は無効です。
