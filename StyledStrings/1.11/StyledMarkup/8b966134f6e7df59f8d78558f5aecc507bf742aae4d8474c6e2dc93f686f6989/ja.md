```julia
StyledMarkup
```

`StyledStrings`のサブモジュールで、スタイル付きマークアップ文字列の解析を専門に扱います。そのため、次の2つのエントリーポイントが用意されています。

  * 一般にこちらが推奨される、[`styled""`](@ref @styled_str)文字列マクロ。
  * 必要に応じて、実行時に与えられる文字列を扱える[`styled`](@ref styled)関数。

全体として、このモジュールは状態機械として機能し、詳細なエラー報告などの便利な機能がいくつか加わっています。設計の概要は、次の図にほぼ集約されています。

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

もちろん、いつものことながら、細部が重要です。
