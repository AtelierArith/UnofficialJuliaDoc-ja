```julia
highlightcand(cand::HistEntry) -> AnnotatedString
```

Juliaの内容は構文強調表示し、それ以外はそのまま出力します。

タブはスペースに展開されます。端末によってタブの幅が異なるためです。`textwidth`
