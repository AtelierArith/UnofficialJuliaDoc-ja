```
Base.Pairs(values, keys) <: AbstractDict{eltype(keys), eltype(values)}
```

Transforms an indexable container into a Dictionary-view of the same data. Modifying the key-space of the underlying data may invalidate this object.
