```
copy_oftype(A, T)
```

Creates a copy of `A` with eltype `T`. No assertions about mutability of the result are made. When `eltype(A) == T`, then this calls `copy(A)` which may be overloaded for custom array types. Otherwise, this calls `convert(AbstractArray{T}, A)`.
