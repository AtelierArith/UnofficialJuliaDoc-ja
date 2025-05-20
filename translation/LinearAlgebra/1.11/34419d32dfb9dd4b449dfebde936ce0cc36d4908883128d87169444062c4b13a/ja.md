```
qr(A, pivot = NoPivot(); blocksize) -> F
```

行列 `A` の QR 分解を計算します：直交行列（または `A` が複素数の場合はユニタリ行列）`Q` と上三角行列 `R` で、次のようになります。

$$
A = Q R
$$

返されるオブジェクト `F` は、パック形式で分解を格納します：

  * `pivot == ColumnNorm()` の場合、`F` は [`QRPivoted`](@ref) オブジェクトです。
  * それ以外の場合、`A` の要素型が BLAS 型（[`Float32`](@ref)、[`Float64`](@ref)、`ComplexF32` または `ComplexF64`）である場合、`F` は [`QRCompactWY`](@ref) オブジェクトです。
  * それ以外の場合、`F` は [`QR`](@ref) オブジェクトです。

分解 `F` の個々のコンポーネントはプロパティアクセサを介して取得できます：

  * `F.Q`: 直交/ユニタリ行列 `Q`
  * `F.R`: 上三角行列 `R`
  * `F.p`: ピボットの置換ベクトル（[`QRPivoted`](@ref) のみ）
  * `F.P`: ピボットの置換行列（[`QRPivoted`](@ref) のみ）

!!! note
    `F.R` を介して上三角因子に各参照を行うと、新しい配列が割り当てられます。したがって、その配列をキャッシュすることをお勧めします。たとえば、`R = F.R` として、`R` で作業を続けます。


分解を反復することで、コンポーネント `Q`、`R`、および存在する場合は `p` を生成します。

`QR` オブジェクトに対しては、次の関数が利用可能です：[`inv`](@ref)、[`size`](@ref)、および [`\`](@ref)。`A` が長方形の場合、`\` は最小二乗解を返し、解が一意でない場合は、最小ノルムのものが返されます。`A` がフルランクでない場合、最小ノルム解を得るためには（列）ピボッティングを伴う分解が必要です。

フル/正方行列または非フル/正方行列 `Q` に関しての乗算が許可されています。つまり、`F.Q*F.R` と `F.Q*A` の両方がサポートされています。`Q` 行列は [`Matrix`](@ref) を使用して通常の行列に変換できます。この操作は「薄い」Q 因子を返します。すなわち、`A` が `m`×`n` で `m>=n` の場合、`Matrix(F.Q)` は直交正規列を持つ `m`×`n` 行列を生成します。「フル」Q 因子を取得するには、`F.Q*I` または `collect(F.Q)` を使用します。`m<=n` の場合、`Matrix(F.Q)` は `m`×`m` の直交行列を生成します。

QR 分解のブロックサイズは、`pivot == NoPivot()` かつ `A isa StridedMatrix{<:BlasFloat}` の場合にキーワード引数 `blocksize :: Integer` で指定できます。`blocksize > minimum(size(A))` の場合は無視されます。[`QRCompactWY`](@ref) を参照してください。

!!! compat "Julia 1.4"
    `blocksize` キーワード引数は Julia 1.4 以降が必要です。


# 例

```jldoctest
julia> A = [3.0 -6.0; 4.0 -8.0; 0.0 1.0]
3×2 Matrix{Float64}:
 3.0  -6.0
 4.0  -8.0
 0.0   1.0

julia> F = qr(A)
LinearAlgebra.QRCompactWY{Float64, Matrix{Float64}, Matrix{Float64}}
Q 因子: 3×3 LinearAlgebra.QRCompactWYQ{Float64, Matrix{Float64}, Matrix{Float64}}
R 因子:
2×2 Matrix{Float64}:
 -5.0  10.0
  0.0  -1.0

julia> F.Q * F.R == A
true
```

!!! note
    `qr` は複数の型を返します。なぜなら、LAPACK はハウスホルダー基本反射の積のメモリストレージ要件を最小限に抑えるためにいくつかの表現を使用するため、`Q` と `R` 行列を2つの別々の密行列としてではなく、コンパクトに格納できるからです。


```
