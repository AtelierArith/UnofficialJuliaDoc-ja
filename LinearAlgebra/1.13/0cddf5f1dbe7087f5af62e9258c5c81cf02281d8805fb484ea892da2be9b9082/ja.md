```julia
svd(A; full::Bool = false, alg::Algorithm = default_svd_alg(A), atol::Real=0, rtol::Real=0) -> SVD
```

`A` の特異値分解（SVD）を計算し、`SVD` オブジェクトを返します。

`U`、`S`、`V`、`Vt` は、`F.U`、`F.S`、`F.V`、`F.Vt` を用いた因数分解 `F` から得られます。このとき、`A = U * Diagonal(S) * Vt` が成り立ちます。このアルゴリズムは `Vt` を生成するため、`Vt` は `V` より効率よく取り出せます。`S` 内の特異値は降順に並んでいます。

分解を反復すると、成分 `U`、`S`、`V` が得られます。

`full = false`（デフォルト）の場合、「thin」SVD が返されます。``M \times N`` 行列 `A` について、完全分解では `U` は ``M \times M``、`V` は ``N \times N`` です。一方、thin 分解では `U` は ``M \times K``、`V` は ``N \times K`` です。ここで、``K = \min(M,N)`` は特異値の個数です。

`alg` は、SVD に使用するアルゴリズムと LAPACK の手法を指定します。

  * `alg = LinearAlgebra.DivideAndConquer()`（デフォルト）：`LAPACK.gesdd!` を呼び出します。
  * `alg = LinearAlgebra.QRIteration()`：`LAPACK.gesvd!` を呼び出します（通常は低速ですが、より高精度です）。

`atol` と `rtol` は、SVD を打ち切るための省略可能な許容誤差を指定します。`max(atol, rtol*σ₁)` 未満の特異値は削除され（ゼロに設定され）ます。ここで、`σ₁` は `A` の最大特異値です。

!!! compat "Julia 1.3"
    `alg` キーワード引数を使用するには、Julia 1.3 以降が必要です。


!!! compat "Julia 1.13"
    `atol` 引数と `rtol` 引数を使用するには、Julia 1.13 以降が必要です。


# Examples

```jldoctest
julia> A = rand(4,3);

julia> F = svd(A); # Store the Factorization Object

julia> A ≈ F.U * Diagonal(F.S) * F.Vt
true

julia> U, S, V = F; # destructuring via iteration

julia> A ≈ U * Diagonal(S) * V'
true

julia> Uonly, = svd(A); # Store U only

julia> Uonly == U
true
```
