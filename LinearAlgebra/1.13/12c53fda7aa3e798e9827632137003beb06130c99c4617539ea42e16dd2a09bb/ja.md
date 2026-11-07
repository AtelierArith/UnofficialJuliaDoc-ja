```julia
qr(A, pivot = NoPivot(); blocksize) -> F
```

行列 `A` の QR 分解を計算します。すなわち、次式を満たす直交行列（`A` が複素数値の場合はユニタリ行列）`Q` と上三角行列 `R` を求めます。

```math
A = Q R
```

返されるオブジェクト `F` は、分解をコンパクトな形式で格納します。

  * `pivot == ColumnNorm()` の場合、`F` は [`QRPivoted`](@ref) オブジェクトです。
  * それ以外で、`A` の要素型が BLAS 型（[`Float32`](@ref)、[`Float64`](@ref)、`ComplexF32` または `ComplexF64`）の場合、`F` は [`QRCompactWY`](@ref) オブジェクトです。
  * それ以外の場合、`F` は [`QR`](@ref) オブジェクトです。

分解 `F` の各成分は、プロパティアクセサーで取得できます。

  * `F.Q`: 直交行列またはユニタリ行列 `Q`
  * `F.R`: 上三角行列 `R`
  * `F.p`: ピボット選択に伴う置換ベクトル（[`QRPivoted`](@ref) のみ）
  * `F.P`: ピボット選択に伴う置換行列（[`QRPivoted`](@ref) のみ）

!!! note
    `F.R` を介して上三角因子を参照するたびに、新しい配列が割り当てられます。そのため、たとえば `R = F.R` でその配列をキャッシュし、以後は `R` を使って処理することをお勧めします。


分解を反復処理すると、成分 `Q`、`R`、および存在する場合は `p` が得られます。

`QR` オブジェクトでは、[`inv`](@ref)、[`size`](@ref)、[`\`](@ref) の各関数を使用できます。`A` が長方形行列の場合、`\` は最小二乗解を返します。解が一意でない場合は、そのうちノルムが最小の解を返します。`A` がフルランクでない場合、最小ノルム解を得るには、（列）ピボット選択付きの分解が必要です。

完全な正方行列としての `Q` に対しても、そうでない場合に対しても乗算が可能です。つまり、`F.Q*F.R` と `F.Q*A` の両方がサポートされています。`Q` 行列は、[`Matrix`](@ref) で通常の行列に変換できます。この操作は「薄い」Q 因子を返します。すなわち、`A` が `m`×`n` 行列で、`m>=n` の場合、`Matrix(F.Q)` は列が正規直交する `m`×`n` 行列を返します。「完全な」Q 因子、つまり `m`×`m` の直交行列を取得するには、`F.Q*I` または `collect(F.Q)` を使用します。`m<=n` の場合、`Matrix(F.Q)` は `m`×`m` の直交行列を返します。

`pivot == NoPivot()` かつ `A isa StridedMatrix{<:BlasFloat}` の場合、QR 分解のブロックサイズをキーワード引数 `blocksize :: Integer` で指定できます。`blocksize > minimum(size(A))` の場合、この引数は無視されます。[`QRCompactWY`](@ref) を参照してください。

!!! compat "Julia 1.4"
    キーワード引数 `blocksize` には Julia 1.4 以降が必要です。


# Examples

```jldoctest
julia> A = [3.0 -6.0; 4.0 -8.0; 0.0 1.0]
3×2 Matrix{Float64}:
 3.0  -6.0
 4.0  -8.0
 0.0   1.0

julia> F = qr(A)
LinearAlgebra.QRCompactWY{Float64, Matrix{Float64}, Matrix{Float64}}
Q factor: 3×3 LinearAlgebra.QRCompactWYQ{Float64, Matrix{Float64}, Matrix{Float64}}
R factor:
2×2 Matrix{Float64}:
 -5.0  10.0
  0.0  -1.0

julia> F.Q * F.R == A
true
```

!!! note
    `qr` が複数の型を返すのは、LAPACK が Householder 基本鏡映の積に必要な記憶容量を最小限に抑えるため、複数の表現を使用しているためです。これにより、`Q` と `R` の行列を、別々の密行列としてではなく、コンパクトに格納できます。

