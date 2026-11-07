```julia
Base.dataids(A::AbstractArray)
```

Return a tuple of `UInt`s that represent the mutable data segments of an array.

Custom arrays that would like to opt-in to aliasing detection of their component parts can specialize this method to return the concatenation of the `dataids` of their component parts.  A typical definition for an array that wraps a parent is `Base.dataids(C::CustomArray) = dataids(C.parent)`.
