```julia
rmul!(A, B)
```

行列の積 $AB$ を計算し、`A` を上書きして結果を返します。ここで、`B` は特別な行列タイプでなければなりません。例えば、[`Diagonal`](@ref)、[`UpperTriangular`](@ref) または [`LowerTriangular`](@ref) のような、または [`QR`](@ref) のような何らかの直交タイプです。

# 例

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
