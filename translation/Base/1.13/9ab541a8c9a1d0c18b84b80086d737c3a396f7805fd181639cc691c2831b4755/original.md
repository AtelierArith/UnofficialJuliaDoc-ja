```julia
Base.datatype_fielddesc_type(dt::DataType)::Int
```

Return the size in bytes of each field-description entry in the layout array, located at `(dt.layout + sizeof(DataTypeLayout))`. Can be called on any `isconcretetype`.

See also [`fieldoffset`](@ref).
