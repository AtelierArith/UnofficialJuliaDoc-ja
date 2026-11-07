```julia
ldiv!(A, B)
```

`A \ B` をインプレースで計算し、`B` を上書きして結果を格納します。

引数 `A` は行列ではなく、因子分解オブジェクト（たとえば [`factorize`](@ref) または [`cholesky`](@ref) で生成されるもの）である必要があります。因子分解自体はコストが高く、通常はメモリを割り当てるためです（ただし、たとえば [`lu!`](@ref) を使ってインプレースで行うこともできます）。また、`ldiv!` が必要となるようなパフォーマンス重視の状況では、通常、`A` の因子分解を細かく制御する必要もあります。

!!! note
    `Diagonal` や `UpperTriangular` など、すでに因子分解された形式になっている一部の構造化行列型は使用できます。


# Examples

```jldoctest
julia> A = [1 2.2 4; 3.1 0.2 3; 4 1 2];

julia> B = [1, 2.5, 3];

julia> B0 = copy(B); # a backup copy to facilitate testing

julia> ldiv!(lu(A), B); # you may also try lu!(A) to further reduce allocation

julia> B ≈ A \ B0
true
```
