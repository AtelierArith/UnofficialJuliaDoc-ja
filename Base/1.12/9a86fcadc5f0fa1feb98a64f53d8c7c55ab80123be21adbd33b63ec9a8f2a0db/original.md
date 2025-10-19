```julia
has_offset_axes(A)
has_offset_axes(A, B, ...)
```

Return `true` if the indices of `A` start with something other than 1 along any axis. If multiple arguments are passed, equivalent to `has_offset_axes(A) || has_offset_axes(B) || ...`.

See also [`require_one_based_indexing`](@ref).
