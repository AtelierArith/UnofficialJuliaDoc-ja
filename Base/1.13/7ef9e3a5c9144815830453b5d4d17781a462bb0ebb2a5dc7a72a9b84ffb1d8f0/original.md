```julia
Base.datatype_isbitsegal(dt::DataType)::Bool
```

Return whether egality of the (non-padding bits of the) in-memory representation of an instance of this type implies semantic egality of the instance itself. This may not be the case if the type contains to other values whose egality is independent of their identity (e.g. immutable structs, some types, etc.).
