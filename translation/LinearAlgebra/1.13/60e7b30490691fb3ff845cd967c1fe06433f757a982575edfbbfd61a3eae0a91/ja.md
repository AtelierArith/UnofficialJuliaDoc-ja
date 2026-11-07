```julia
lmul!(A, B)
```

行列積 ``AB`` を計算し、`B` に上書きして、結果を返します。ここで、`A` は、たとえば [`Diagonal`](@ref)、[`UpperTriangular`](@ref)、[`LowerTriangular`](@ref) のような特殊な行列型、または直交型である必要があります。詳しくは [`QR`](@ref) を参照してください。

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
