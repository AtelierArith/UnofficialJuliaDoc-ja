```julia
gethover(state::SelectorState) -> Union{HistEntry, Nothing}
```

カーソル位置（ホバー位置）にある `HistEntry` を返すか、`nothing` を返します。

`candidates` の正のホバーと、`gathered` の負のホバーを処理します。
