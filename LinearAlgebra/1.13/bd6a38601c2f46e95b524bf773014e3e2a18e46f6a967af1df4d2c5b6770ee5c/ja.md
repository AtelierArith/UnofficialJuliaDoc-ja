```julia
eigen(A::Union{SymTridiagonal, Hermitian, Symmetric}, irange::UnitRange) -> Eigen
```

`A` の固有値分解を計算し、固有値を `F.values` に、正規直交固有ベクトルを行列 `F.vectors` の列に格納した、[`Eigen`](@ref) 分解オブジェクト `F` を返します。（`k` 番目の固有ベクトルは、スライス `F.vectors[:, k]` から取得できます。）

この分解を反復すると、成分 `F.values` と `F.vectors` が得られます。

`Eigen` オブジェクトでは、次の関数を使用できます：[`inv`](@ref)、[`det`](@ref)、[`isposdef`](@ref)。

[`UnitRange`](@ref) `irange` は、検索対象とするソート済み固有値のインデックスを指定します。

!!! note
    `irange` が `1:n` と等しくない場合（`n` は `A` の次元）、返される分解は *切り詰められた* 分解になります。

