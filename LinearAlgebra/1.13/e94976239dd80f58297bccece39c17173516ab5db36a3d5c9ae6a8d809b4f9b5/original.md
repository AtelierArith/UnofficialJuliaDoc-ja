```julia
_vectranspose(A::AbstractVector)::AbstractVector
```

Compute `vec(transpose(A))`, but avoid an allocating reshape if possible
