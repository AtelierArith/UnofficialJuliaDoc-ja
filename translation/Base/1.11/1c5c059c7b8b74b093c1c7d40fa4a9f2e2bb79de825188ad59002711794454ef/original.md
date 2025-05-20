```
IndexCartesian()
```

Subtype of [`IndexStyle`](@ref) used to describe arrays which are optimally indexed by a Cartesian index. This is the default for new custom [`AbstractArray`](@ref) subtypes.

A Cartesian indexing style uses multiple integer indices to describe the position in a multidimensional array, with exactly one index per dimension. This means that requesting [`eachindex`](@ref) from an array that is `IndexCartesian` will return a range of [`CartesianIndices`](@ref).

A `N`-dimensional custom array that reports its `IndexStyle` as `IndexCartesian` needs to implement indexing (and indexed assignment) with exactly `N` `Int` indices; all other indexing expressions — including linear indexing — will be recomputed to the equivalent Cartesian location.  For example, if `A` were a `2×3` custom matrix with cartesian indexing, and we referenced `A[5]`, this would be recomputed to the equivalent Cartesian index and call `A[1, 3]` since `5 = 1 + 2*(3 - 1)`.

It is significantly more expensive to compute Cartesian indices from a linear index than it is to go the other way.  The former operation requires division — a very costly operation — whereas the latter only uses multiplication and addition and is essentially free. This asymmetry means it is far more costly to use linear indexing with an `IndexCartesian` array than it is to use Cartesian indexing with an `IndexLinear` array.

See also [`IndexLinear`](@ref).
