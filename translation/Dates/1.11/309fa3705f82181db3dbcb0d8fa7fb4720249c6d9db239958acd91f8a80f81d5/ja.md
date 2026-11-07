```julia
tryparsenext_core(str::AbstractString, pos::Int, len::Int, df::DateFormat, raise=false)
```

`DateFormat` 内の指示に従って文字列を解析します。解析は文字インデックス `pos` から開始し、すべての指示を使い切るか、文字列の末尾 `len` まで解析した時点で終了します。指示を解析できない場合、`raise` が false なら戻り値は `nothing` となり、true なら例外がスローされます。

解析に成功した場合、3 要素のタプル `(values, pos, num_parsed)` を返します。

  * `values::Tuple`: `DateFormat` 内の各 `DatePart` に対応する値を、出現順に格納したタプルです。すべての指示を解析し終える前に文字列の末尾に達した場合、残りの値にはデフォルト値が設定されます。
  * `pos::Int`: 解析が停止した文字インデックスです。
  * `num_parsed::Int`: 解析され、`values` に格納された値の数です。解析済みの値とデフォルト値を区別するのに役立ちます。
