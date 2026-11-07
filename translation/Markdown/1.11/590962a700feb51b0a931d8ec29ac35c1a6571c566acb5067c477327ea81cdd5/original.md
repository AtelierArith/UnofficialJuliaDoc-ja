```julia
wraplines(content::AnnotatedString, width::Integer = 80, column::Integer = 0)
```

Wrap `content` into a vector of lines of at most `width` (according to `textwidth`), with the first line starting at `column`.
