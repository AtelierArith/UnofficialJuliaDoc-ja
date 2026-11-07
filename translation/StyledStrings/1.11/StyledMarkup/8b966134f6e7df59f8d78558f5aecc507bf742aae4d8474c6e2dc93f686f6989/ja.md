```julia
StyledMarkup
```

`StyledStrings` のサブモジュールで、スタイル付きマークアップ文字列の解析を専門に扱います。そのため、次の2つのエントリーポイントが用意されています。

  * 通常はこちらを使う [`styled""`](@ref @styled_str) 文字列マクロ。
  * 必要に応じて、実行時に渡される文字列を扱える [`styled`](@ref styled) 関数。

このモジュールは基本的に状態機械として機能し、詳細なエラー報告などの便利な機能がいくつか加わっています。全体的な設計は、次の図にほぼ集約されています。

```text
╭String─────────╮
│ Styled markup │
╰──────┬────────╯
       │╭╴[module]
       ││
      ╭┴┴State─╮
      ╰┬───────╯
       │
 ╭╴run_state_machine!╶╮
 │              ╭─────┼─╼ escaped!
 │ Apply rules: │     │
 │  "\\" ▶──────╯ ╭───┼─╼[interpolated!] ──▶ readexpr!, addpart!
 │  "$" ▶────────╯   │
 │  "{"  ▶────────────┼─╼ begin_style! ──▶ read_annotation!
 │  "}"  ▶─────╮      │                     ├─╼ read_inlineface! [readexpr!]
 │             ╰──────┼─╼ end_style!        ╰─╼ read_face_or_keyval!
 │ addpart!(...)      │
 ╰╌╌╌╌╌┬╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯
       │
       ▼
     Result
```

もちろん、いつものことながら、細部が肝心です。
