```julia
peek_behind(ps; skip_trivia=true, skip_parens=true)
peek_behind(ps, pos::ParseStreamPosition)
```

以前出力に挿入されたスパンに関する情報を返します。`skip_trivia` が true の場合は、直前にある最も近い非トリビアノードを対象とします。それ以外の場合は、指定された位置 `pos` を対象とします。

パーサーの出力を遡って調べたり変更したりすると混乱を招くことがあるため、可能な限りこの関数の使用は避けてください。
