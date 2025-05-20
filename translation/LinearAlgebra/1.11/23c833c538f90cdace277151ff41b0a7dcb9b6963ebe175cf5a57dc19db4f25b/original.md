```
lmul!(A, B)
```

Calculate the matrix-matrix product $AB$, overwriting `B`, and return the result. Here, `A` must be of special matrix type, like, e.g., [`Diagonal`](@ref), [`UpperTriangular`](@ref) or [`LowerTriangular`](@ref), or of some orthogonal type, see [`QR`](@ref).

# Examples

```jldoctest
julia> B = [0 1; 1 0];

julia> A = UpperTriangular([1 2; 0 3]);

julia> lmul!(A, B);

julia> B
2×2 Matrix{Int64}:
 2  1
 3  0

julia> B = [1.0 2.0; 3.0 4.0];

julia> F = qr([0 1; -1 0]);

julia> lmul!(F.Q, B)
2×2 Matrix{Float64}:
 3.0  4.0
 1.0  2.0
```
