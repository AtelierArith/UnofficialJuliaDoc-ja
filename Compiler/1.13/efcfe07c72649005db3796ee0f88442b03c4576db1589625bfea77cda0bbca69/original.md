```julia
constrains_param(var::TypeVar, sig, covariant::Bool, type_constrains::Bool)
```

Check if `var` will be constrained to have a definite value in any concrete leaftype subtype of `sig`.

It is used as a helper to determine whether type intersection is guaranteed to be able to find a value for a particular type parameter. A necessary condition for type intersection to not assign a parameter is that it only appears in a `Union[All]` and during subtyping some other union component (that does not constrain the type parameter) is selected.

The `type_constrains` flag determines whether Type{T} is considered to be constraining `T`. This is not true in general, because of the existence of types with free type parameters, however, some callers would like to ignore this corner case.
