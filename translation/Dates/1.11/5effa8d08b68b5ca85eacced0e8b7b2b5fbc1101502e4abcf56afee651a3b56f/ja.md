```julia
parse_components(str::AbstractString, df::DateFormat)::Array{Any}
```

文字列を`DateFormat`の指示に従って解析し、各要素に分割します。各要素はそれぞれ異なる型で、通常はPeriodのサブタイプです。要素の順序は、`DateFormat`内の`DatePart`の指示の順序と一致します。要素の数は、`DatePart`の総数より少ない場合があります。
