```julia
boxedcontent(io::IO, content::AnnotatedString, width::Int, maxlines::Int) -> Int
```

Draw `content` inside a Unicode box, wrapping or truncating to `width` and `maxlines`.

Returns the number of printed lines.
