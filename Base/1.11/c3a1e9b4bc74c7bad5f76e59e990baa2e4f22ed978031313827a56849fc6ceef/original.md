```
copy!(dst, src) -> dst
```

In-place [`copy`](@ref) of `src` into `dst`, discarding any pre-existing elements in `dst`. If `dst` and `src` are of the same type, `dst == src` should hold after the call. If `dst` and `src` are multidimensional arrays, they must have equal [`axes`](@ref).

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.


See also [`copyto!`](@ref).

!!! compat "Julia 1.1"
    This method requires at least Julia 1.1. In Julia 1.0 this method is available from the `Future` standard library as `Future.copy!`.

