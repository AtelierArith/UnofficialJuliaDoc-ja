```julia
IRShowConfig
```

  * `line_info_preprinter(io::IO, indent::String, idx::Int)``may print relevant info at the beginning of the line, and should at least print`indent`。最終的な基本ブロック注釈の後に出力される文字列を返します。
  * `line_info_postprinter(io::IO; type, used::Bool, show_type::Bool, idx::Int)`は、型注釈などの関連情報を文の末尾に出力します。
  * `should_print_stmt(idx::Int) -> Bool`: インデックス`idx`の文をIRの一部として出力するかどうか
  * `bb_color`: 左側の基本ブロック括弧の出力に使う色
  * `label_dynamic_calls`: 呼び出しをdynamic / builtin / intrinsicとしてラベル付けするかどうか
