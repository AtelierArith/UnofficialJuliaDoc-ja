```
iszerodefined(T::Type)
```

Return a `Bool` indicating whether `iszero` is well-defined for objects of type `T`. By default, this function returns `false` unless `T <: Number`. Note that this function may return `true` even if `zero(::T)` is not defined as long as `iszero(::T)` has a method that does not requires `zero(::T)`.

This function is used to determine if mapping the elements of an array with a specific structure of nonzero elements preserve this structure. For instance, it is used to determine whether the output of `tuple.(Diagonal([1, 2]))` is `Diagonal([(1,), (2,)])` or `[(1,) (0,); (0,) (2,)]`. For this, we need to determine whether `(0,)` is considered to be zero. `iszero((0,))` falls back to `(0,) == zero((0,))` which fails as `zero(::Tuple{Int})` is not defined. However, `iszerodefined(::Tuple{Int})` is `false` hence we falls back to the comparison `(0,) == 0` which returns `false` and decides that the correct output is `[(1,) (0,); (0,) (2,)]`.
