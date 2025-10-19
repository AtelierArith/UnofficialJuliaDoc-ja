```julia
lmul!(A, B)
```

行列の積 $AB$ を計算し、`B` を上書きして結果を返します。ここで、`A` は特別な行列タイプでなければならず、例えば [`Diagonal`](@ref)、[`UpperTriangular`](@ref) または [`LowerTriangular`](@ref)、または何らかの直交タイプである必要があります。詳細は [`QR`](@ref) を参照してください。

# 例

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
