```julia
sqrt(A::AbstractMatrix)
```

`A` に負の実固有値がない場合は、`A` の主行列平方根を計算します。これは、固有値の実部が正である唯一の行列 ``X`` であり、``X^2 = A`` を満たします。それ以外の場合は、非主平方根が返されます。

`A` が実対称またはエルミート行列の場合は、その固有分解（[`eigen`](@ref)）を使って平方根を計算します。このような行列では、丸め誤差によってわずかに負になったように見える固有値は、ゼロとして扱われます。より正確には、すべての固有値が `≥ -rtol*(max |λ|)` である行列は半正定値として扱われ（エルミート平方根が得られます）、負の固有値はゼロとみなされます。`rtol` は `sqrt` のキーワード引数（エルミート／実対称の場合のみ）で、既定値は `size(A,1)` でスケーリングした機械精度です。

それ以外の場合、平方根は Björck-Hammarling 法 [^BH83] によって求めます。この方法では、複素シュール形式（[`schur`](@ref)）を計算し、続いて三角因子の複素平方根を求めます。実平方根が存在する場合は、この方法を拡張した手法 [^H87] を用います。この手法では、実シュール形式を計算した後、準三角因子の実平方根を求めます。

[^BH83]: Åke Björck and Sven Hammarling, "A Schur method for the square root of a matrix", Linear Algebra and its Applications, 52-53, 1983, 127-140. [doi:10.1016/0024-3795(83)80010-X](https://doi.org/10.1016/0024-3795(83)80010-X)

[^H87]: Nicholas J. Higham, "Computing real square roots of a real matrix", Linear Algebra and its Applications, 88-89, 1987, 405-430. [doi:10.1016/0024-3795(87)90118-2](https://doi.org/10.1016/0024-3795(87)90118-2)

# Examples

```jldoctest
julia> A = [4 0; 0 4]
2×2 Matrix{Int64}:
 4  0
 0  4

julia> sqrt(A)
2×2 Matrix{Float64}:
 2.0  0.0
 0.0  2.0
```
