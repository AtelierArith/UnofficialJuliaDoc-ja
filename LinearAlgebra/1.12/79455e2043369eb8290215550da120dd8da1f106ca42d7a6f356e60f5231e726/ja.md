```julia
eigvals(A::Union{Hermitian, Symmetric}; alg::Algorithm = default_eigen_alg(A))) -> values
```

行列 `A` の固有値を返します。

`alg` は固有値分解に使用するアルゴリズムとLAPACKメソッドを指定します：

  * `alg = DivideAndConquer()`: `LAPACK.syevd!` を呼び出します。
  * `alg = QRIteration()`: `LAPACK.syev!` を呼び出します。
  * `alg = RobustRepresentations()` (デフォルト): 複数の比較的堅牢な表現法、`LAPACK.syevr!` を呼び出します。

異なるメソッドの精度と性能の比較については、James W. Demmel らの SIAM J. Sci. Comput. 30, 3, 1508 (2008) を参照してください。

将来的に使用されるデフォルトの `alg` は変更される可能性があります。

!!! compat "Julia 1.12"
    `alg` キーワード引数は Julia 1.12 以降が必要です。

