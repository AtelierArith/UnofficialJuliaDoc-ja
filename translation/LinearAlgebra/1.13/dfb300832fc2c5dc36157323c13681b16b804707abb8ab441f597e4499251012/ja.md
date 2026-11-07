```julia
rmul!(A, B)
```

行列積 ``AB`` を計算し、`A` に上書きして、結果を返します。ここで、`B` は、たとえば [`Diagonal`](@ref)、[`UpperTriangular`](@ref)、[`LowerTriangular`](@ref) のような特殊な行列型、または直交型である必要があります。詳しくは [`QR`](@ref) を参照してください。

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
