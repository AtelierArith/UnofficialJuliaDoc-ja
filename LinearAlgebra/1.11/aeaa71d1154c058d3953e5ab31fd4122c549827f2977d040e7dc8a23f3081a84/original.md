```
rmul!(A, B)
```

Calculate the matrix-matrix product $AB$, overwriting `A`, and return the result. Here, `B` must be of special matrix type, like, e.g., [`Diagonal`](@ref), [`UpperTriangular`](@ref) or [`LowerTriangular`](@ref), or of some orthogonal type, see [`QR`](@ref).

# Examples

```jldoctest
julia> A = [0 1; 1 0];

julia> B = UpperTriangular([1 2; 0 3]);

julia> rmul!(A, B);

julia> A
2×2 Matrix{Int64}:
 0  3
 1  2

julia> A = [1.0 2.0; 3.0 4.0];

julia> F = qr([0 1; -1 0]);

julia> rmul!(A, F.Q)
2×2 Matrix{Float64}:
 2.0  1.0
 4.0  3.0
```
