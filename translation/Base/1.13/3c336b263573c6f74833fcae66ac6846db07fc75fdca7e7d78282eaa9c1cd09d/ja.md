```julia
annotated_chartransform(f::Function, str::AnnotatedString, state=nothing)
```

`str` のすべての文字を `f` で変換し、必要に応じてアノテーション領域を調整します。`f` は、次のいずれかの形式である必要があります。

  * `f(c::Char) -> Char`
  * `f(c::Char, state) -> (Char, state)`

これは、`f` で変換する前後の各文字のコード単位数を比較し、その差を記録して集計したうえで、アノテーション領域に反映することで実現します。

元の `str` の文字列型にかかわらず、`AnnotatedString{String}` を返します。
