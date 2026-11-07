```julia
select_keymap(events::Channel{Symbol})
```

`events` にシンボルを追加する REPL.LineEdit のキーマップを構築します。

矢印キー、ページキー、Tab、Ctrl-C/D/S、meta-< / > を、プロンプトループを制御する `Event` または `Returns` のアクションに割り当てます。
