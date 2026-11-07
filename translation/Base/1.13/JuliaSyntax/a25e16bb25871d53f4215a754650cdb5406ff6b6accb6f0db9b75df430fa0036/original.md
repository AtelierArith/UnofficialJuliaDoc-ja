```julia
source_location(x)
source_location(source::SourceFile, byte_index::Integer)

source_location(LineNumberNode, x)
source_location(LineNumberNode, source, byte_index)
```

Get `(line,column)` of the first byte where object `x` appears in the source. The second form allows one to be more precise with the `byte_index`, given the source file.

Providing `LineNumberNode` as the first argument will return the line and file name in a line number node object.
