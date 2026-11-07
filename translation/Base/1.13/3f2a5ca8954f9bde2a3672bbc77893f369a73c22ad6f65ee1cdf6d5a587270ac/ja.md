```julia
_insert_annotations!(io::AnnotatedIOBuffer, annotations::Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}, offset::Int = position(io))
```

新しい `annotations` を `io` に登録し、その領域に `offset` を適用します。

この処理の大部分は、`annotations` の領域を `offset` だけずらし、`io` の注釈に追加するだけです。ただし、[`AnnotatedString`](@ref) で説明されている意味に従って、新しい注釈を直近の注釈と統合できる場合は、統合します。具体的には、直近の注釈のうち、同じ値を持ち、領域が隣接しているものが、最初の `annotations` にも連続して含まれている場合、新しい注釈を既存の直近の注釈に統合し、その範囲を延長します。

これにより、たとえば `AnnotatedIOBuffer` に `AnnotatedString` を1文字ずつ書き込む場合でも、文字ごとに新しい注釈を不必要に作成せずに済みます。
