```julia
eigvals(A::Union{Hermitian, Symmetric}; alg::Algorithm = default_eigen_alg(A))) -> values
```

`A` の固有値を返します。

`alg` は、固有値分解に使用するアルゴリズムと LAPACK の手法を指定します。

  * `alg = DivideAndConquer()`: `LAPACK.syevd!` を呼び出します。
  * `alg = QRIteration()`: `LAPACK.syev!` を呼び出します。
  * `alg = RobustRepresentations()`（デフォルト）: 複数の相対的にロバストな表現を用いる手法です。`LAPACK.syevr!` を呼び出します。

各手法の精度と性能の比較については、James W. Demmel ほか、SIAM J. Sci. Comput. 30, 3, 1508 (2008) を参照してください。

使用されるデフォルトの `alg` は、将来変更される可能性があります。

!!! compat "Julia 1.12"
    `alg` キーワード引数を使用するには、Julia 1.12 以降が必要です。

