```julia
hoveridx(state::SelectorState) -> Int
```

ホバー時に、`candidates` または `gathered` への符号付きインデックスを計算します。

正の値は `candidates`、負の値は `gathered` をインデックスします。0 は無効です。
