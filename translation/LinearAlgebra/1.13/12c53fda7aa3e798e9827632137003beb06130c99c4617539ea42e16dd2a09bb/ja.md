```julia
qr(A, pivot = NoPivot(); blocksize) -> F
```

行列 `A` の QR 分解を計算します。直交行列（`A` が複素数の場合はユニタリ行列）`Q` と、次の条件を満たす上三角行列 `R` を求めます。

```math
A = Q R
```

返されるオブジェクト `F` は、分解結果をパック形式で保持します。

  * `pivot == ColumnNorm()` の場合、`F` は [`QRPivoted`](@ref) オブジェクトです。
  * それ以外で、`A` の要素型が BLAS 型（[`Float32`](@ref)、[`Float64`](@ref)、`ComplexF32`、または `ComplexF64`）の場合、`F` は [`QRCompactWY`](@ref) オブジェクトです。
  * それ以外の場合、`F` は [`QR`](@ref) オブジェクトです。

分解結果 `F` の各成分は、プロパティアクセサーで取得できます。

  * `F.Q`: 直交／ユニタリ行列 `Q`
  * `F.R`: 上三角行列 `R`
  * `F.p`: ピボットの置換ベクトル（[`QRPivoted`](@ref) の場合のみ）
  * `F.P`: ピボットの置換行列（[`QRPivoted`](@ref) の場合のみ）

!!! note
    `F.R` を介して上三角因子を参照するたびに、新しい配列が割り当てられます。そのため、たとえば `R = F.R` によって配列をキャッシュし、以降は `R` を使って処理を続けることをお勧めします。


分解結果を反復処理すると、成分 `Q`、`R`、および（存在する場合は）`p` が得られます。

`QR` オブジェクトでは、次の関数を使用できます: [`inv`](@ref)、[`size`](@ref)、[`\`](@ref)。`A` が長方形行列の場合、`\` は最小二乗解を返します。解が一意でない場合は、ノルムが最小の解を返します。`A` がフルランクでない場合、最小ノルム解を得るには（列）ピボット付きの分解が必要です。

完全／正方形または不完全／非正方形の `Q` のいずれについても、乗算が可能です。つまり、`F.Q*F.R` と `F.Q*A` の両方がサポートされています。`Q` 行列は、[`Matrix`](@ref) によって通常の行列に変換できます。この操作は「thin」Q 因子を返します。すなわち、`A` が `m`×`n` で、`m>=n` の場合、`Matrix(F.Q)` は、列が正規直交する `m`×`n` 行列を返します。「full」Q 因子、つまり `m`×`m` の直交行列を取得するには、`F.Q*I` または `collect(F.Q)` を使用します。`m<=n` の場合、`Matrix(F.Q)` は `m`×`m` の直交行列を返します。

QR 分解のブロックサイズは、`pivot == NoPivot()` および `A isa StridedMatrix{<:BlasFloat}` の場合、キーワード引数 `blocksize :: Integer` で指定できます。`blocksize > minimum(size(A))` の場合、この引数は無視されます。詳しくは [`QRCompactWY`](@ref) を参照してください。

!!! compat "Julia 1.4"
    `blocksize` キーワード引数を使用するには、Julia 1.4 以降が必要です。


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
    LAPACK は、Householder 基本反射の積に必要なメモリを抑えるため、複数の表現を使用します。そのため、`qr` は複数の型を返します。これにより、`Q` 行列と `R` 行列を、別々の密行列としてではなく、コンパクトに格納できます。

