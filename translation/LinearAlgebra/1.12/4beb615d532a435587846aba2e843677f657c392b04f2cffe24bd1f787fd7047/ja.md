```julia
eigen(A::Union{Hermitian, Symmetric}; alg::LinearAlgebra.Algorithm = LinearAlgebra.default_eigen_alg(A)) -> Eigen
```

行列 `A` の固有値分解を計算し、固有値を `F.values` に、直交正規固有ベクトルを行列 `F.vectors` の列に含む [`Eigen`](@ref) 因子化オブジェクト `F` を返します。（`k` 番目の固有ベクトルはスライス `F.vectors[:, k]` から取得できます。）

分解を反復することで、成分 `F.values` と `F.vectors` を得ることができます。

`alg` は固有値分解に使用するアルゴリズムと LAPACK メソッドを指定します：

  * `alg = DivideAndConquer()`: `LAPACK.syevd!` を呼び出します。
  * `alg = QRIteration()`: `LAPACK.syev!` を呼び出します。
  * `alg = RobustRepresentations()`（デフォルト）: 複数の比較的堅牢な表現法、`LAPACK.syevr!` を呼び出します。

異なるアルゴリズムの精度と性能の比較については、James W. Demmel et al, SIAM J. Sci. Comput. 30, 3, 1508 (2008) を参照してください。

将来的に使用されるデフォルトの `alg` は変更される可能性があります。

!!! compat "Julia 1.12"
    `alg` キーワード引数は Julia 1.12 以降が必要です。


`Eigen` オブジェクトに対して利用可能な関数は次のとおりです: [`inv`](@ref), [`det`](@ref), および [`isposdef`](@ref).
