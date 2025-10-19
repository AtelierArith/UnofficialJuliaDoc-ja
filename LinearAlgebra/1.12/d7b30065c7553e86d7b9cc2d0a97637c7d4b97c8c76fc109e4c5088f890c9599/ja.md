```julia
eigen(A::Union{SymTridiagonal, Hermitian, Symmetric}, vl::Real, vu::Real) -> Eigen
```

行列 `A` の固有値分解を計算し、固有値を `F.values` に、直交正規固有ベクトルを行列 `F.vectors` の列に含む [`Eigen`](@ref) 因子化オブジェクト `F` を返します。（`k` 番目の固有ベクトルはスライス `F.vectors[:, k]` から取得できます。）

分解を反復することで、コンポーネント `F.values` と `F.vectors` を得ることができます。

`Eigen` オブジェクトに対して利用可能な関数は次のとおりです: [`inv`](@ref), [`det`](@ref), および [`isposdef`](@ref)。

`vl` は検索する固有値のウィンドウの下限であり、`vu` は上限です。

!!! note
    [`vl`, `vu`] に `A` のすべての固有値が含まれていない場合、返される因子化は *切り捨てられた* 因子化になります。

