```julia
boxedcontent(io::IO, content::AnnotatedString, width::Int, maxlines::Int) -> Int
```

`content`をUnicodeの枠内に描画し、`width`と`maxlines`に合わせて折り返すか切り詰めます。

出力された行数を返します。
