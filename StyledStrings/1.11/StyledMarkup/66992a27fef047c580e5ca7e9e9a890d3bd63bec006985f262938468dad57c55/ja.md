```
StyledMarkup
```

`StyledStrings`のサブモジュールで、スタイル付きマークアップ文字列の解析を特に扱います。この目的のために、2つのエントリーポイントが提供されています：

  * 一般的に推奨される[`styled""`](@ref @styled_str)文字列マクロ。
  * 必要に応じて、ランタイムで提供される文字列と一緒に使用できる[`styled`](@ref styled)関数。

全体として、このモジュールは基本的にいくつかの追加の便利さ（詳細なエラーレポートなど）が加えられた状態機械として機能します。全体の設計は、以下の図で大まかに要約できます：

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

もちろん、いつものように、悪魔は細部に宿ります。
