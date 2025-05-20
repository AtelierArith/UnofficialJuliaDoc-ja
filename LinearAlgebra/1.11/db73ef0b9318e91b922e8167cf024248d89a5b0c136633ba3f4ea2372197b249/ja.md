```
eigen(A::Union{SymTridiagonal, Hermitian, Symmetric}, irange::UnitRange) -> Eigen
```

行列 `A` の固有値分解を計算し、固有値を `F.values` に、固有ベクトルを行列 `F.vectors` の列に含む [`Eigen`](@ref) 因子化オブジェクト `F` を返します。（`k` 番目の固有ベクトルはスライス `F.vectors[:, k]` から取得できます。）

分解を反復すると、コンポーネント `F.values` と `F.vectors` が得られます。

`Eigen` オブジェクトに対して利用可能な関数は次のとおりです: [`inv`](@ref), [`det`](@ref), および [`isposdef`](@ref)。

[`UnitRange`](@ref) `irange` は、検索するソートされた固有値のインデックスを指定します。

!!! note
    `irange` が `1:n` でない場合、ここで `n` は `A` の次元であるため、返される因子化は *切り捨てられた* 因子化になります。

