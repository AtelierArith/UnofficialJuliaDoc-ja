```julia
highlightcand(cand::HistEntry) -> AnnotatedString
```

Juliaの内容は構文強調表示し、それ以外の内容はそのまま返します。

タブはスペースに展開されます。端末ではタブの幅が`textwidth`とは異なるためです。
