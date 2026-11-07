```julia
merge(initial::StyledStrings.Face, others::StyledStrings.Face...)
```

Merge the properties of the `initial` face and `others`, with later faces taking priority.

This is used to combine the styles of multiple faces, and to resolve inheritance.
