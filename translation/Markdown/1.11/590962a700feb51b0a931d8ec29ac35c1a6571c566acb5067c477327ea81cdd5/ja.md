```julia
wraplines(content::AnnotatedString, width::Integer = 80, column::Integer = 0)
```

`content`を、`textwidth`に従って、各行が最大`width`となる行ベクトルに折り返します。最初の行は`column`から始めます。
