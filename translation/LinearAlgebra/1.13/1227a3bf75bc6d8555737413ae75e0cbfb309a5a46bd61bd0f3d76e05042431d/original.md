```julia
_vecadjoint(A::AbstractVector)::AbstractVector
```

Compute `vec(adjoint(A))`, but avoid an allocating reshape if possible
