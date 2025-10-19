```julia
haszero(T::Type)
```

Return whether a type `T` has a unique zero element defined using `zero(T)`. If a type `M` specializes `zero(M)`, it may also choose to set `haszero(M)` to `true`. By default, `haszero` is assumed to be `false`, in which case the zero elements are deduced from values rather than the type.

!!! note
    `haszero` is a conservative check that is used to dispatch to optimized paths. Extending it is optional, but encouraged.

