```julia
isless(A::AbstractVector, B::AbstractVector)
```

Return `true` when `A` is less than `B`. Vectors are first compared by their starting indices, and then lexicographically by their elements.
