```julia
source_line(x)
source_line(source::SourceFile, byte_index::Integer)
```

Get the line number of the first line on which object `x` appears. In the second form, get the line number at the given `byte_index` within `source`.
