```julia
select_keymap(events::Channel{Symbol})
```

`events` にシンボルをプッシュする REPL.LineEdit のキーマップを構築します。

矢印キー、ページキー、Tab、Ctrl-C/D/S、meta-< / > を、プロンプトループを操作するための `Event` または `Returns` アクションに割り当てます。
