```julia
peek_behind(ps; skip_trivia=true, skip_parens=true)
peek_behind(ps, pos::ParseStreamPosition)
```

出力に以前挿入されたスパンに関する情報を返します。`skip_trivia` が true の場合は、直近の非トリビアノードをデフォルトとして返し、それ以外の場合は指定された位置 `pos` の情報を返します。

パーサーの出力を遡って調べたり変更したりすると混乱を招くことがあるため、可能な限りこの関数の使用は避けてください。
