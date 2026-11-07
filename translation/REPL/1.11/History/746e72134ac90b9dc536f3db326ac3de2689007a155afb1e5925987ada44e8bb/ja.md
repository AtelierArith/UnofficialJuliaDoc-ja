```julia
boxedcontent(io::IO, content::AnnotatedString, width::Int, maxlines::Int) -> Int
```

`content`をUnicodeの枠内に描画し、`width`に折り返すか、`maxlines`に切り詰めます。

出力した行数を返します。
