```julia
eigen(A::Union{SymTridiagonal, Hermitian, Symmetric}, vl::Real, vu::Real) -> Eigen
```

`A` の固有値分解を計算し、固有値を `F.values` に、正規直交固有ベクトルを行列 `F.vectors` の列に格納した、[`Eigen`](@ref) の分解オブジェクト `F` を返します。（`k` 番目の固有ベクトルは、スライス `F.vectors[:, k]` から取得できます。）

この分解を反復すると、成分 `F.values` と `F.vectors` が得られます。

`Eigen` オブジェクトでは、次の関数を使用できます：[`inv`](@ref)、[`det`](@ref)、[`isposdef`](@ref)。

`vl` は検索対象とする固有値の範囲の下限、`vu` は上限です。

!!! note
    [`vl`, `vu`] に `A` のすべての固有値が含まれていない場合、返される分解は *切り詰められた* 分解になります。

