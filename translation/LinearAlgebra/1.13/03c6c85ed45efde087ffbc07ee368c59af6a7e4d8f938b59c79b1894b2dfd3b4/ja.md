```julia
ldiv!(A::Tridiagonal, B::AbstractVecOrMat) -> B
```

`A \ B` を部分ピボット選択付きガウス消去法でインプレースに計算し、結果を `B` に格納して返します。この処理では、`A` の対角要素も上書きされます。

!!! compat "Julia 1.11"
    `ldiv!` を `Tridiagonal` の左辺に使用するには、Julia 1.11 以降が必要です。

