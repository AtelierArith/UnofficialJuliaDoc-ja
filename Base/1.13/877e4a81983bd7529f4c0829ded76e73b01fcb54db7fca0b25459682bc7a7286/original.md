```julia
Base.datatype_arrayelem(dt::DataType)::Int
```

Return the behavior of the trailing array types allocations. Can be called on any `isconcretetype`, but only meaningful on `Memory`.

0 = inlinealloc 1 = isboxed 2 = isbitsunion
