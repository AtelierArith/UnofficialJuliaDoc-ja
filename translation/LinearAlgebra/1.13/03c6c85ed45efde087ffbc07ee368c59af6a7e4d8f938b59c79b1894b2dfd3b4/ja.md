```julia
ldiv!(A::Tridiagonal, B::AbstractVecOrMat) -> B
```

`A \ B`を部分ピボット選択付きガウス消去法でインプレースに計算し、結果を`B`に格納して返します。この処理では、`A`の対角成分も上書きされます。

!!! compat "Julia 1.11"
    左辺が`Tridiagonal`である場合の`ldiv!`には、Julia 1.11以降が必要です。

