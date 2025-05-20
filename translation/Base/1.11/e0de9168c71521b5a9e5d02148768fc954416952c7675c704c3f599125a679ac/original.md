```
empty(a::AbstractDict, [index_type=keytype(a)], [value_type=valtype(a)])
```

Create an empty `AbstractDict` container which can accept indices of type `index_type` and values of type `value_type`. The second and third arguments are optional and default to the input's `keytype` and `valtype`, respectively. (If only one of the two types is specified, it is assumed to be the `value_type`, and the `index_type` we default to `keytype(a)`).

Custom `AbstractDict` subtypes may choose which specific dictionary type is best suited to return for the given index and value types, by specializing on the three-argument signature. The default is to return an empty `Dict`.
