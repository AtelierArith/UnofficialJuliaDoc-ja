```julia
sourcefile(x)
```

Get the source file object (usually `SourceFile`) for a given syntax object `x`. The source file along with a byte range may be used to compute `source_line()`, `source_location()`, `filename()`, etc.
