```julia
Future{T}
```

Assign-once delayed return value for a value of type `T`, similar to RefValue{T}. Can be constructed in one of three ways:

1. With an immediate as `Future{T}(val)`
2. As an assign-once storage location with `Future{T}()`. Assigned (once) using `f[] = val`.
3. As a delayed computation with `Future{T}(callback, dep, interp, sv)` to have `sv` arrange to call the `callback` with the result of `dep` when it is ready.

Use `isready` to check if the value is ready, and `getindex` to get the value.
