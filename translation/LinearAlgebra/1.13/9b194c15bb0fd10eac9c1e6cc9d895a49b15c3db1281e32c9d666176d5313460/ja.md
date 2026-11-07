```julia
eigen(A::Union{Hermitian, Symmetric}; alg::LinearAlgebra.Algorithm = LinearAlgebra.default_eigen_alg(A)) -> Eigen
```

`A` の固有値分解を計算し、固有値を `F.values` に、正規直交固有ベクトルを行列 `F.vectors` の列に含む、[`Eigen`](@ref) の分解オブジェクト `F` を返します。（`k` 番目の固有ベクトルは、スライス `F.vectors[:, k]` から取得できます。）

この分解を反復すると、成分 `F.values` と `F.vectors` が得られます。

`alg` は、固有値分解に使用するアルゴリズムと LAPACK の手法を指定します。

  * `alg = DivideAndConquer()`: `LAPACK.syevd!` を呼び出します。
  * `alg = QRIteration()`: `LAPACK.syev!` を呼び出します。
  * `alg = RobustRepresentations()`（デフォルト）: 複数の相対的にロバストな表現を用いる手法です。`LAPACK.syevr!` を呼び出します。

各アルゴリズムの精度と性能の比較については、James W. Demmel et al, SIAM J. Sci. Comput. 30, 3, 1508 (2008) を参照してください。

今後、使用されるデフォルトの `alg` が変更される可能性があります。

!!! compat "Julia 1.12"
    `alg` キーワード引数を使用するには、Julia 1.12 以降が必要です。


`Eigen` オブジェクトでは、次の関数を使用できます: [`inv`](@ref)、[`det`](@ref)、[`isposdef`](@ref)。
