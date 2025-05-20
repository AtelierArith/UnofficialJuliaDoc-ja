```
tryparsenext_core(str::AbstractString, pos::Int, len::Int, df::DateFormat, raise=false)
```

`DateFormat`内の指示に従って文字列を解析します。解析は文字インデックス`pos`から始まり、すべての指示が使用されるか、文字列の終わり`len`まで解析が完了するまで停止します。指示を解析できない場合、`raise`がfalseであれば返される値は`nothing`、それ以外の場合は例外がスローされます。

成功した場合、3要素のタプル`(values, pos, num_parsed)`を返します：

  * `values::Tuple`: `DateFormat`内の各`DatePart`に対する値を含むタプルで、発生する順序で並んでいます。文字列がすべての指示を解析する前に終了した場合、欠落している値はデフォルト値で埋められます。
  * `pos::Int`: 解析が停止した文字インデックス。
  * `num_parsed::Int`: 解析されて`values`内に格納された値の数。デフォルト値と解析された値を区別するのに役立ちます。
