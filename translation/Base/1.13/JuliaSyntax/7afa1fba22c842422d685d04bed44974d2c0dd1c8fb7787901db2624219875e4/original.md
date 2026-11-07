```julia
ParseState(stream::ParseStream)
```

ParseState is an internal data structure wrapping `ParseStream` to carry parser context as we recursively descend into the parse tree. For example, normally `x -y` means `(x) - (y)`, but when parsing matrix literals we're in `space_sensitive` mode, and `[x -y]` means [(x) (-y)].
