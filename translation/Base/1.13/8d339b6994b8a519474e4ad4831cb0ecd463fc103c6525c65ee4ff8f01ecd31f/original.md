```julia
Base.datatype_nfields(dt::DataType)::UInt32
```

Return the number of fields known to this datatype's layout. This may be different from the number of actual fields of the type for opaque types. Can be called on any `isconcretetype`.
