```
copyto!(dest::AbstractMatrix, src::UniformScaling)
```

Copies a [`UniformScaling`](@ref) onto a matrix.

!!! compat "Julia 1.1"
    In Julia 1.0 this method only supported a square destination matrix. Julia 1.1. added support for a rectangular matrix.

