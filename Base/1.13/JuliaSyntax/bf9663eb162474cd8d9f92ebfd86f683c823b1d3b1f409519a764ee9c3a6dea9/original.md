```julia
SourceFile(code [; filename=nothing, first_line=1, first_index=1])
```

UTF-8 source text with associated file name and line number, storing the character indices of the start of each line. `first_line` and `first_index` can be used to specify the line number and index of the first character of `code` within a larger piece of source text.

`SourceFile` may be indexed via `getindex` or `view` to get a string.  Line information for a byte offset can be looked up via the `source_line`, `source_location` and `source_line_range` functions.
