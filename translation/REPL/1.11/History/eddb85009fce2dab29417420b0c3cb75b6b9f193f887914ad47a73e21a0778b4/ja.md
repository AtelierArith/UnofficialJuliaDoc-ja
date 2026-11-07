```julia
update_candidates(io::IO, oldcands::CandsState, newcands::CandsState, force::Bool = false)
```

`io` を更新して、表示を `oldcands` から `newcands` に変更します。

変更箇所のみが出力され、出力される行数はちょうど `length(newcands.entries)` 行です。
