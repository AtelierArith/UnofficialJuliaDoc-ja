```julia
opnorm(A::AbstractMatrix, p::Real=2)
```

Compute the operator norm (or matrix norm) induced by the vector `p`-norm, where valid values of `p` are `1`, `2`, or `Inf`. (Note that for sparse matrices, `p=2` is currently not implemented.) Use [`norm`](@ref) to compute the Frobenius norm.

When `p=1`, the operator norm is the maximum absolute column sum of `A`:

$$
\|A\|_1 = \max_{1 ≤ j ≤ n} \sum_{i=1}^m | a_{ij} |
$$

with $a_{ij}$ the entries of $A$, and $m$ and $n$ its dimensions.

When `p=2`, the operator norm is the spectral norm, equal to the largest singular value of `A`.

When `p=Inf`, the operator norm is the maximum absolute row sum of `A`:

$$
\|A\|_\infty = \max_{1 ≤ i ≤ m} \sum _{j=1}^n | a_{ij} |
$$

# Examples

```jldoctest
julia> A = [1 -2 -3; 2 3 -1]
2×3 Matrix{Int64}:
 1  -2  -3
 2   3  -1

julia> opnorm(A, Inf)
6.0

julia> opnorm(A, 1)
5.0
```
