```julia
Base.datatype_haspadding(dt::DataType) -> Bool
```

Return whether the fields of instances of this type are packed in memory, with no intervening padding bits (defined as bits whose value does not impact the semantic value of the instance itself). Can be called on any `isconcretetype`.
