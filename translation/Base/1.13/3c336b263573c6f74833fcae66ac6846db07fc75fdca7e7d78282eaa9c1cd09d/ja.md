```julia
annotated_chartransform(f::Function, str::AnnotatedString, state=nothing)
```

`str` のすべての文字を `f` で変換し、必要に応じてアノテーション領域を調整します。`f` は、次のいずれかの形式である必要があります。

  * `f(c::Char) -> Char`
  * `f(c::Char, state) -> (Char, state)`

これは、`f` による変換の前後で各文字のコード単位数を比較し、差分を記録・集計したうえで、その差分をアノテーション領域に適用することで実現します。

戻り値は `AnnotatedString{String}` です（`str` の元の文字列型にかかわらず）。
