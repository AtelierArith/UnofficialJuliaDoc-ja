```julia
Base.ismutationfree(T)
```

Determine whether type `T` is mutation free in the sense that no mutable memory is reachable from this type (either in the type itself) or through any fields. Note that the type itself need not be immutable. For example, an empty mutable type is `ismutabletype`, but also `ismutationfree`. If `T` is not a type, then return `false`.
