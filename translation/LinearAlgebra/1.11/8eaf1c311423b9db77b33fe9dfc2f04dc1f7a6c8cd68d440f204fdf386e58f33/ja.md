```
ldiv!(A::Tridiagonal, B::AbstractVecOrMat) -> B
```

`A \ B`をガウス消去法による部分ピボットを用いてインプレースで計算し、結果を`B`に格納して返します。この過程で、`A`の対角成分も上書きされます。

!!! compat "Julia 1.11"
    `Tridiagonal`の左辺に対する`ldiv!`は、少なくともJulia 1.11が必要です。

