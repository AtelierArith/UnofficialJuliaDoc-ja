```julia
canonicalize_typeassert!(compact::IncrementalCompact, idx::Int, stmt::Expr)
```

Canonicalizes `X = typeassert(Y, T)::S` into `typeassert(Y, T); X = π(Y, S)` so that subsequent analysis only has to deal with the latter form.

N.B. Inference may have a more precise type for `S`, than just `T`, but from here on out, there's no problem with just using that. We should probably have a version of `typeassert` that's defined not to return its value to make life easier for the backend.
