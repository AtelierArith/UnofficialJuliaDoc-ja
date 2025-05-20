```
@RCI f
```

records the function `f` to be overwritten (and restored) with `allowscalar(::Bool)`. This is an experimental feature.

Note that it will evaluate the function in the top level of the package. The original code for `f` is stored in `_restore_scalar_indexing` and a function that has the same definition as `f` but returns an error is stored in `_destroy_scalar_indexing`.
