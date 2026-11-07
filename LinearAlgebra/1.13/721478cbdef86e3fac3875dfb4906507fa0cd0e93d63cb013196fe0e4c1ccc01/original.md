```julia
zeroslike(::Type{M}, ax::Tuple{AbstractUnitRange, Vararg{AbstractUnitRange}}) where {M<:AbstractMatrix}
zeroslike(::Type{M}, sz::Tuple{Integer, Vararg{Integer}}) where {M<:AbstractMatrix}
```

Return an appropriate zero-ed array similar to `M`, with either the axes `ax` or the size `sz`. This will be used as a structural zero element of a matrix-valued banded matrix. By default, `zeroslike` falls back to using the size along each axis to construct the array.
