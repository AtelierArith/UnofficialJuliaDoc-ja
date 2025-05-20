```
Base.datatype_alignment(dt::DataType) -> Int
```

Memory allocation minimum alignment for instances of this type. Can be called on any `isconcretetype`, although for Memory it will give the alignment of the elements, not the whole object.
