```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/LinearAlgebra/docs/src/index.md"
```

# [Linear Algebra](@id man-linalg)

```@meta
DocTestSetup = :(using LinearAlgebra)
```

多次元配列をサポートするだけでなく、その一環として、Julia には一般的で便利な線形代数演算の多くがネイティブ実装されており、`using LinearAlgebra` を読み込むことで利用できます。[`tr`](@ref)、[`det`](@ref)、[`inv`](@ref) などの基本演算がサポートされています。

```jldoctest
julia> A = [1 2 3; 4 1 6; 7 8 1]
3×3 Matrix{Int64}:
 1  2  3
 4  1  6
 7  8  1

julia> tr(A)
3

julia> det(A)
104.0

julia> inv(A)
3×3 Matrix{Float64}:
 -0.451923   0.211538    0.0865385
  0.365385  -0.192308    0.0576923
  0.240385   0.0576923  -0.0673077
```

固有値や固有ベクトルの計算など、ほかにも便利な演算が用意されています。

```jldoctest
julia> A = [-4. -17.; 2. 2.]
2×2 Matrix{Float64}:
 -4.0  -17.0
  2.0    2.0

julia> eigvals(A)
2-element Vector{ComplexF64}:
 -1.0 - 5.0im
 -1.0 + 5.0im

julia> eigvecs(A)
2×2 Matrix{ComplexF64}:
  0.945905-0.0im        0.945905+0.0im
 -0.166924+0.278207im  -0.166924-0.278207im
```

また、線形方程式の求解や行列のべき乗計算などを高速化するために、行列を問題に適した形式（性能やメモリ使用量の面で有利な形式）にあらかじめ因数分解する、さまざまな [factorizations](@ref man-linalg-factorizations) も用意されています。詳しくは [`factorize`](@ref) のドキュメントを参照してください。例を示します。

```jldoctest
julia> A = [1.5 2 -4; 3 -1 -6; -10 2.3 4]
3×3 Matrix{Float64}:
   1.5   2.0  -4.0
   3.0  -1.0  -6.0
 -10.0   2.3   4.0

julia> factorize(A)
LU{Float64, Matrix{Float64}, Vector{Int64}}
L factor:
3×3 Matrix{Float64}:
  1.0    0.0       0.0
 -0.15   1.0       0.0
 -0.3   -0.132196  1.0
U factor:
3×3 Matrix{Float64}:
 -10.0  2.3     4.0
   0.0  2.345  -3.4
   0.0  0.0    -5.24947
```

`A` はエルミート行列、対称行列、三角行列、三重対角行列、二重対角行列のいずれでもないため、最善の方法は LU 分解だと考えられます。次の例と比較してください。

```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Matrix{Float64}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> factorize(B)
BunchKaufman{Float64, Matrix{Float64}, Vector{Int64}}
D factor:
3×3 Tridiagonal{Float64, Vector{Float64}}:
 -1.64286   0.0   ⋅
  0.0      -2.8  0.0
   ⋅        0.0  5.0
U factor:
3×3 UnitUpperTriangular{Float64, Matrix{Float64}}:
 1.0  0.142857  -0.8
  ⋅   1.0       -0.6
  ⋅    ⋅         1.0
permutation:
3-element Vector{Int64}:
 1
 2
 3
```

ここでは、Julia が `B` を実際には対称行列だと判定し、より適切な分解を使用できました。対称行列や三重対角行列など、特定の性質を持つことが分かっている行列については、より効率的なコードを書ける場合がよくあります。Julia には、行列にこうした性質を「タグ付け」するための特殊な型が用意されています。たとえば、次のようにします。

```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Matrix{Float64}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> sB = Symmetric(B)
3×3 Symmetric{Float64, Matrix{Float64}}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0
```

`sB` には（実）対称行列であるというタグが付いています。そのため、固有分解や行列とベクトルの積など、後続の演算では行列の半分だけを参照して効率化できます。たとえば、次のとおりです。

```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Matrix{Float64}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> sB = Symmetric(B)
3×3 Symmetric{Float64, Matrix{Float64}}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> x = [1; 2; 3]
3-element Vector{Int64}:
 1
 2
 3

julia> sB\x
3-element Vector{Float64}:
 -1.7391304347826084
 -1.1086956521739126
 -1.4565217391304346
```

ここでの `\` 演算が線形方程式を解きます。左除算演算子は非常に強力で、さまざまな連立一次方程式を解ける柔軟性を備えた、簡潔で読みやすいコードを簡単に書けます。

## Special matrices

[Matrices with special symmetries and structures](https://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=3274) は線形代数で頻繁に登場し、さまざまな行列分解と関連付けられることもよくあります。Julia には特殊な行列型が豊富に用意されており、特定の行列型向けに開発された専用ルーチンを使って高速に計算できます。

以下の表では、Julia に実装されている特殊行列型と、それらに対する LAPACK の各種最適化メソッドへのフックが利用可能かどうかをまとめています。

| 型                             | 説明                                                                                   |
|:----------------------------- |:------------------------------------------------------------------------------------ |
| [`Symmetric`](@ref)           | [Symmetric matrix](https://en.wikipedia.org/wiki/Symmetric_matrix)                   |
| [`Hermitian`](@ref)           | [Hermitian matrix](https://en.wikipedia.org/wiki/Hermitian_matrix)                   |
| [`UpperTriangular`](@ref)     | 上三角 [triangular matrix](https://en.wikipedia.org/wiki/Triangular_matrix)             |
| [`UnitUpperTriangular`](@ref) | 対角成分がすべて 1 の上三角 [triangular matrix](https://en.wikipedia.org/wiki/Triangular_matrix) |
| [`LowerTriangular`](@ref)     | 下三角 [triangular matrix](https://en.wikipedia.org/wiki/Triangular_matrix)             |
| [`UnitLowerTriangular`](@ref) | 対角成分がすべて 1 の下三角 [triangular matrix](https://en.wikipedia.org/wiki/Triangular_matrix) |
| [`UpperHessenberg`](@ref)     | 上三角 [Hessenberg matrix](https://en.wikipedia.org/wiki/Hessenberg_matrix)             |
| [`Tridiagonal`](@ref)         | [Tridiagonal matrix](https://en.wikipedia.org/wiki/Tridiagonal_matrix)               |
| [`SymTridiagonal`](@ref)      | 対称三重対角行列                                                                             |
| [`Bidiagonal`](@ref)          | 上／下 [bidiagonal matrix](https://en.wikipedia.org/wiki/Bidiagonal_matrix)             |
| [`Diagonal`](@ref)            | [Diagonal matrix](https://en.wikipedia.org/wiki/Diagonal_matrix)                     |
| [`UniformScaling`](@ref)      | [Uniform scaling operator](https://en.wikipedia.org/wiki/Uniform_scaling)            |

### Elementary operations

| 行列型                           | `+` | `-` | `*` | `\` | 最適化メソッドが用意されているその他の関数                                        |
|:----------------------------- |:--- |:--- |:--- |:--- |:------------------------------------------------------------ |
| [`Symmetric`](@ref)           |     |     |     | MV  | [`inv`](@ref), [`sqrt`](@ref), [`cbrt`](@ref), [`exp`](@ref) |
| [`Hermitian`](@ref)           |     |     |     | MV  | [`inv`](@ref), [`sqrt`](@ref), [`cbrt`](@ref), [`exp`](@ref) |
| [`UpperTriangular`](@ref)     |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref), [`logdet`](@ref)               |
| [`UnitUpperTriangular`](@ref) |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref), [`logdet`](@ref)               |
| [`LowerTriangular`](@ref)     |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref), [`logdet`](@ref)               |
| [`UnitLowerTriangular`](@ref) |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref), [`logdet`](@ref)               |
| [`UpperHessenberg`](@ref)     |     |     |     | MM  | [`inv`](@ref), [`det`](@ref)                                 |
| [`SymTridiagonal`](@ref)      | M   | M   | MS  | MV  | [`eigmax`](@ref), [`eigmin`](@ref)                           |
| [`Tridiagonal`](@ref)         | M   | M   | MS  | MV  |                                                              |
| [`Bidiagonal`](@ref)          | M   | M   | MS  | MV  |                                                              |
| [`Diagonal`](@ref)            | M   | M   | MV  | MV  | [`inv`](@ref), [`det`](@ref), [`logdet`](@ref), [`/`](@ref)  |
| [`UniformScaling`](@ref)      | M   | M   | MVS | MVS | [`/`](@ref)                                                  |

凡例：

| キー      | 説明                           |
|:------- |:---------------------------- |
| M（行列）   | 行列と行列の演算に最適化されたメソッドを利用できます   |
| V（ベクトル） | 行列とベクトルの演算に最適化されたメソッドを利用できます |
| S（スカラー） | 行列とスカラーの演算に最適化されたメソッドを利用できます |

### Matrix factorizations

| 行列型                           | LAPACK | [`eigen`](@ref) | [`eigvals`](@ref) | [`eigvecs`](@ref) | [`svd`](@ref) | [`svdvals`](@ref) |
|:----------------------------- |:------ |:--------------- |:----------------- |:----------------- |:------------- |:----------------- |
| [`Symmetric`](@ref)           | SY     |                 | ARI               |                   |               |                   |
| [`Hermitian`](@ref)           | HE     |                 | ARI               |                   |               |                   |
| [`UpperTriangular`](@ref)     | TR     | A               | A                 | A                 |               |                   |
| [`UnitUpperTriangular`](@ref) | TR     | A               | A                 | A                 |               |                   |
| [`LowerTriangular`](@ref)     | TR     | A               | A                 | A                 |               |                   |
| [`UnitLowerTriangular`](@ref) | TR     | A               | A                 | A                 |               |                   |
| [`SymTridiagonal`](@ref)      | ST     | A               | ARI               | AV                |               |                   |
| [`Tridiagonal`](@ref)         | GT     |                 |                   |                   |               |                   |
| [`Bidiagonal`](@ref)          | BD     |                 |                   |                   | A             | A                 |
| [`Diagonal`](@ref)            | DI     |                 | A                 |                   |               |                   |

凡例：

| キー      | 説明                                                 | 例                    |
|:------- |:-------------------------------------------------- |:-------------------- |
| A（すべて）  | すべての特性値および／または特性ベクトルを求める最適化メソッドを利用できます             | 例：`eigvals(M)`       |
| R（範囲）   | `il` 番目から `ih` 番目までの特性値を求める最適化メソッドを利用できます          | `eigvals(M, il, ih)` |
| I（区間）   | 区間 [`vl`, `vh`] 内の特性値を求める最適化メソッドを利用できます            | `eigvals(M, vl, vh)` |
| V（ベクトル） | 特性値 `x=[x1, x2,...]` に対応する特性ベクトルを求める最適化メソッドを利用できます | `eigvecs(M, x)`      |

### The uniform scaling operator

[`UniformScaling`](@ref) 演算子は、恒等演算子 `λ*I` にスカラーを掛けたものを表します。恒等演算子 `I` は定数として定義され、`UniformScaling` のインスタンスです。これらの演算子のサイズは汎用的で、二項演算 [`+`](@ref)、[`-`](@ref)、[`*`](@ref)、[`\`](@ref) では、もう一方の行列のサイズに合わせられます。`A+I` と `A-I` の場合、`A` は正方行列でなければなりません。恒等演算子 `I` との乗算は、スケーリング係数が 1 であることの確認を除けば何もしないため、オーバーヘッドはほとんどありません。

`UniformScaling` 演算子の動作を見てみましょう。

```jldoctest
julia> U = UniformScaling(2);

julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> a + U
2×2 Matrix{Int64}:
 3  2
 3  6

julia> a * U
2×2 Matrix{Int64}:
 2  4
 6  8

julia> [a U]
2×4 Matrix{Int64}:
 1  2  2  0
 3  4  0  2

julia> b = [1 2 3; 4 5 6]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> b - U
ERROR: DimensionMismatch: matrix is not square: dimensions are (2, 3)
Stacktrace:
[...]
```

同じ `A` に対して異なる `μ` を用い、`(A+μI)x = b` の形の連立方程式を何度も解く必要がある場合は、まず [`hessenberg`](@ref) 関数を使って `A` のヘッセンベルグ分解 `F` を計算すると効率がよい場合があります。`F` が与えられると、Julia は `(F+μ*I) \ b`（`(A+μ*I)x \ b` と同等）や行列式などの関連演算に効率的なアルゴリズムを使用します。

## [Matrix factorizations](@id man-linalg-factorizations)

[Matrix factorizations (a.k.a. matrix decompositions)](https://en.wikipedia.org/wiki/Matrix_decomposition) は、行列を複数の行列の積に分解するもので、（数値）線形代数の中心的な概念の一つです。

以下の表では、Julia に実装されている行列分解の型をまとめています。各型に関連するメソッドの詳細は、Linear Algebra ドキュメントの [Standard functions](@ref) セクションを参照してください。

| 型                  | 説明                                                                                                                                |
|:------------------ |:--------------------------------------------------------------------------------------------------------------------------------- |
| `BunchKaufman`     | Bunch-Kaufman 分解                                                                                                                  |
| `Cholesky`         | [Cholesky factorization](https://en.wikipedia.org/wiki/Cholesky_decomposition)                                                    |
| `CholeskyPivoted`  | [Pivoted](https://en.wikipedia.org/wiki/Pivot_element) Cholesky 分解                                                                |
| `LDLt`             | [LDL(T) factorization](https://en.wikipedia.org/wiki/Cholesky_decomposition#LDL_decomposition)                                    |
| `LU`               | [LU factorization](https://en.wikipedia.org/wiki/LU_decomposition)                                                                |
| `QR`               | [QR factorization](https://en.wikipedia.org/wiki/QR_decomposition)                                                                |
| `QRCompactWY`      | QR 分解のコンパクト WY 形式                                                                                                                 |
| `QRPivoted`        | ピボット付き [QR factorization](https://en.wikipedia.org/wiki/QR_decomposition)                                                         |
| `LQ`               | `transpose(A)` の [QR factorization](https://en.wikipedia.org/wiki/QR_decomposition)                                               |
| `Hessenberg`       | [Hessenberg decomposition](https://mathworld.wolfram.com/HessenbergDecomposition.html)                                            |
| `Eigen`            | [Spectral decomposition](https://en.wikipedia.org/wiki/Eigendecomposition_of_a_matrix)                                            |
| `GeneralizedEigen` | [Generalized spectral decomposition](https://en.wikipedia.org/wiki/Eigendecomposition_of_a_matrix#Generalized_eigenvalue_problem) |
| `SVD`              | [Singular value decomposition](https://en.wikipedia.org/wiki/Singular_value_decomposition)                                        |
| `GeneralizedSVD`   | [Generalized SVD](https://en.wikipedia.org/wiki/Generalized_singular_value_decomposition#Higher_order_version)                    |
| `Schur`            | [Schur decomposition](https://en.wikipedia.org/wiki/Schur_decomposition)                                                          |
| `GeneralizedSchur` | [Generalized Schur decomposition](https://en.wikipedia.org/wiki/Schur_decomposition#Generalized_Schur_decomposition)              |

[`Factorization`](@ref) オブジェクトの随伴行列と転置行列は、それぞれ `AdjointFactorization` オブジェクトと `TransposeFactorization` オブジェクトで遅延ラップされます。一般に、実数の `Factorization` の転置は `AdjointFactorization` としてラップされます。

## [Orthogonal matrices (`AbstractQ`)](@id man-linalg-abstractq)

行列分解の中には、直交／ユニタリな「行列」因子を生成するものがあります。これには、[`qr`](@ref) の呼び出しで得られる QR 関連の分解（`QR`、`QRCompactWY`、`QRPivoted`）、[`hessenberg`](@ref) の呼び出しで得られるヘッセンベルグ分解、[`lq`](@ref) の呼び出しで得られる LQ 分解があります。これらの直交／ユニタリ因子は行列として表現できますが、性能とメモリ使用量の理由から、内部表現は通常の行列とは異なります。そのため、行列を背後に持つ関数ベースの線形演算子として捉えるのが適切です。特に、たとえば行列表現の列を読み取るには、メモリからデータをそのまま読み出す（構造上のゼロでベクトルの一部を埋める場合もあります）のではなく、「行列」とベクトルの積を計算するコードを実行する必要があります。また、三角行列以外の行列型との明確な違いとして、基盤となる乗算コードでは、乗算中にインプレースで変更できます。さらに、[`qr`](@ref)、[`hessenberg`](@ref)、[`lq`](@ref) で作成されるような特定の `AbstractQ` サブタイプのオブジェクトは、状況に応じて正方行列または長方行列として振る舞います。

```julia
julia> using LinearAlgebra

julia> Q = qr(rand(3,2)).Q
3×3 LinearAlgebra.QRCompactWYQ{Float64, Matrix{Float64}, Matrix{Float64}}

julia> Matrix(Q)
3×2 Matrix{Float64}:
 -0.320597   0.865734
 -0.765834  -0.475694
 -0.557419   0.155628

julia> Q*I
3×3 Matrix{Float64}:
 -0.320597   0.865734  -0.384346
 -0.765834  -0.475694  -0.432683
 -0.557419   0.155628   0.815514

julia> Q*ones(2)
3-element Vector{Float64}:
  0.5451367118802273
 -1.241527373086654
 -0.40179067589600226

julia> Q*ones(3)
3-element Vector{Float64}:
  0.16079054743832022
 -1.674209978965636
  0.41372375588835797

julia> ones(1,2) * Q'
1×3 Matrix{Float64}:
 0.545137  -1.24153  -0.401791

julia> ones(1,3) * Q'
1×3 Matrix{Float64}:
 0.160791  -1.67421  0.413724
```

密行列や構造化行列とはこのように異なるため、抽象型 `AbstractQ` は `AbstractMatrix` のサブタイプではなく、独自の型階層を持ちます。`AbstractQ` のサブタイプとなるカスタム型は、以下のインターフェースを満たせば、汎用フォールバックを利用できます。たとえば、

```julia
struct MyQ{T} <: LinearAlgebra.AbstractQ{T}
    # required fields
end
```

次のメソッドをオーバーロードしてください。

```julia
Base.size(Q::MyQ) # size of corresponding square matrix representation
Base.convert(::Type{AbstractQ{T}}, Q::MyQ) # eltype promotion [optional]
LinearAlgebra.lmul!(Q::MyQ, x::AbstractVecOrMat) # left-multiplication
LinearAlgebra.rmul!(A::AbstractMatrix, Q::MyQ) # right-multiplication
```

`eltype` の型昇格が不要であれば、`convert` メソッドは必要ありません。デフォルトでは `convert(::Type{AbstractQ{T}}, Q::AbstractQ{T})` が `Q` 自体を返すためです。`AbstractQ` 型のオブジェクトの随伴行列は、`AdjointQ` ラッパー型で遅延ラップされます。この型には独自の `LinearAlgebra.lmul!` メソッドと `LinearAlgebra.rmul!` メソッドが必要です。これらのメソッドがあれば、任意の `Q::MyQ` を行列のように使用できます。特に乗算の文脈での使用が適しています。スカラー、ベクトル、行列との左右からの `*` による乗算、`Q` の行列表現の取得（`Matrix(Q)` または `Q*I` を使用）、および行列表現へのインデックスアクセスが可能です。一方、加算や減算、さらに一般に行列表現の要素に対するブロードキャストは、非常に非効率になるため失敗します。こうした用途では、あらかじめ行列表現を計算し、再利用できるようキャッシュすることを検討してください。

## [Pivoting Strategies](@id man-linalg-pivoting-strategies)

Julia の [matrix factorizations](@ref man-linalg-factorizations) の多くは [pivoting](https://en.wikipedia.org/wiki/Pivot_element) に対応しており、数値安定性の向上に利用できます。実際、LU 分解など一部の行列分解は、ピボット選択なしでは失敗することがあります。

ピボット選択では、まずピボット戦略に基づいて、数値的に良好な性質を持つ [pivot element](https://en.wikipedia.org/wiki/Pivot_element) を選びます。次に、選んだ要素が後続の計算に使える位置に来るよう、元の行列の行と列を並べ替えます。この処理を分解の各段階で繰り返します。

そのため、ピボット選択を伴う分解では、通常の行列因子に加えて置換行列も出力されます。

以下では、Julia に実装されているピボット戦略について簡単に説明します。すべての行列分解がこれらの戦略に対応しているとは限りません。対応するピボット戦略の詳細は、各 [matrix factorization](@ref man-linalg-factorizations) のドキュメントを参照してください。

[`LinearAlgebra.ZeroPivotException`](@ref) も参照してください。

```@docs
LinearAlgebra.NoPivot
LinearAlgebra.RowNonZero
LinearAlgebra.RowMaximum
LinearAlgebra.ColumnNorm
```

## Standard functions

Julia の線形代数関数の多くは、[LAPACK](https://www.netlib.org/lapack/) の関数を呼び出して実装されています。疎行列の分解では、[SuiteSparse](http://suitesparse.com) の関数が呼び出されます。その他の疎行列ソルバーは Julia のパッケージとして利用できます。

```@docs
Base.:*(::AbstractMatrix, ::AbstractMatrix)
Base.:*(::AbstractMatrix, ::AbstractMatrix, ::AbstractVector)
Base.:\(::AbstractMatrix, ::AbstractVecOrMat)
Base.:/(::AbstractVecOrMat, ::AbstractVecOrMat)
LinearAlgebra.SingularException
LinearAlgebra.PosDefException
LinearAlgebra.ZeroPivotException
LinearAlgebra.RankDeficientException
LinearAlgebra.LAPACKException
LinearAlgebra.dot
LinearAlgebra.dot(::Any, ::Any, ::Any)
LinearAlgebra.cross
LinearAlgebra.axpy!
LinearAlgebra.axpby!
LinearAlgebra.rotate!
LinearAlgebra.reflect!
LinearAlgebra.factorize
LinearAlgebra.Diagonal
LinearAlgebra.Bidiagonal
LinearAlgebra.SymTridiagonal
LinearAlgebra.Tridiagonal
LinearAlgebra.Symmetric
LinearAlgebra.Hermitian
LinearAlgebra.LowerTriangular
LinearAlgebra.UpperTriangular
LinearAlgebra.UnitLowerTriangular
LinearAlgebra.UnitUpperTriangular
LinearAlgebra.UpperHessenberg
LinearAlgebra.UniformScaling
LinearAlgebra.I
LinearAlgebra.UniformScaling(::Integer)
LinearAlgebra.Factorization
LinearAlgebra.LU
LinearAlgebra.lu
LinearAlgebra.lu!
LinearAlgebra.Cholesky
LinearAlgebra.CholeskyPivoted
LinearAlgebra.cholesky
LinearAlgebra.cholesky!
LinearAlgebra.lowrankupdate
LinearAlgebra.lowrankdowndate
LinearAlgebra.lowrankupdate!
LinearAlgebra.lowrankdowndate!
LinearAlgebra.LDLt
LinearAlgebra.ldlt
LinearAlgebra.ldlt!
LinearAlgebra.QR
LinearAlgebra.QRCompactWY
LinearAlgebra.QRPivoted
LinearAlgebra.qr
LinearAlgebra.qr!
LinearAlgebra.LQ
LinearAlgebra.lq
LinearAlgebra.lq!
LinearAlgebra.BunchKaufman
LinearAlgebra.bunchkaufman
LinearAlgebra.bunchkaufman!
LinearAlgebra.Eigen
LinearAlgebra.GeneralizedEigen
LinearAlgebra.eigvals
LinearAlgebra.eigvals!
LinearAlgebra.eigmax
LinearAlgebra.eigmin
LinearAlgebra.eigvecs
LinearAlgebra.eigen
LinearAlgebra.eigen!
LinearAlgebra.Hessenberg
LinearAlgebra.hessenberg
LinearAlgebra.hessenberg!
LinearAlgebra.Schur
LinearAlgebra.GeneralizedSchur
LinearAlgebra.schur
LinearAlgebra.schur!
LinearAlgebra.ordschur
LinearAlgebra.ordschur!
LinearAlgebra.SVD
LinearAlgebra.GeneralizedSVD
LinearAlgebra.svd
LinearAlgebra.svd!
LinearAlgebra.svdvals
LinearAlgebra.svdvals!
LinearAlgebra.Givens
LinearAlgebra.givens
LinearAlgebra.triu
LinearAlgebra.triu!
LinearAlgebra.tril
LinearAlgebra.tril!
LinearAlgebra.diagind
LinearAlgebra.diag
LinearAlgebra.diagm
LinearAlgebra.rank
LinearAlgebra.norm
LinearAlgebra.opnorm
LinearAlgebra.normalize!
LinearAlgebra.normalize
LinearAlgebra.cond
LinearAlgebra.condskeel
LinearAlgebra.tr
LinearAlgebra.det
LinearAlgebra.logdet
LinearAlgebra.logabsdet
Base.inv(::AbstractMatrix)
LinearAlgebra.pinv
LinearAlgebra.nullspace
Base.kron
Base.kron!
LinearAlgebra.exp(::AbstractMatrix)
Base.cis(::AbstractMatrix)
Base.:^(::AbstractMatrix, ::Number)
Base.:^(::Number, ::AbstractMatrix)
LinearAlgebra.log(::AbstractMatrix)
LinearAlgebra.sqrt(::AbstractMatrix)
LinearAlgebra.cbrt(::AbstractMatrix{<:Real})
LinearAlgebra.cos(::AbstractMatrix{<:Real})
LinearAlgebra.sin(::AbstractMatrix{<:Real})
LinearAlgebra.sincos(::AbstractMatrix{<:Real})
LinearAlgebra.tan(::AbstractMatrix)
LinearAlgebra.sec(::AbstractMatrix)
LinearAlgebra.csc(::AbstractMatrix)
LinearAlgebra.cot(::AbstractMatrix)
LinearAlgebra.cosh(::AbstractMatrix)
LinearAlgebra.sinh(::AbstractMatrix)
LinearAlgebra.tanh(::AbstractMatrix)
LinearAlgebra.sech(::AbstractMatrix)
LinearAlgebra.csch(::AbstractMatrix)
LinearAlgebra.coth(::AbstractMatrix)
LinearAlgebra.acos(::AbstractMatrix)
LinearAlgebra.asin(::AbstractMatrix)
LinearAlgebra.atan(::AbstractMatrix)
LinearAlgebra.asec(::AbstractMatrix)
LinearAlgebra.acsc(::AbstractMatrix)
LinearAlgebra.acot(::AbstractMatrix)
LinearAlgebra.acosh(::AbstractMatrix)
LinearAlgebra.asinh(::AbstractMatrix)
LinearAlgebra.atanh(::AbstractMatrix)
LinearAlgebra.asech(::AbstractMatrix)
LinearAlgebra.acsch(::AbstractMatrix)
LinearAlgebra.acoth(::AbstractMatrix)
LinearAlgebra.lyap
LinearAlgebra.sylvester
LinearAlgebra.issuccess
LinearAlgebra.issymmetric
LinearAlgebra.isposdef
LinearAlgebra.isposdef!
LinearAlgebra.istril
LinearAlgebra.istriu
LinearAlgebra.isdiag
LinearAlgebra.ishermitian
Base.transpose
LinearAlgebra.transpose!
LinearAlgebra.Transpose
LinearAlgebra.TransposeFactorization
Base.adjoint
LinearAlgebra.adjoint!
LinearAlgebra.Adjoint
LinearAlgebra.AdjointFactorization
Base.copy(::Union{Transpose,Adjoint})
LinearAlgebra.stride1
LinearAlgebra.checksquare
LinearAlgebra.peakflops
LinearAlgebra.hermitianpart
LinearAlgebra.hermitianpart!
LinearAlgebra.copy_adjoint!
LinearAlgebra.copy_transpose!
LinearAlgebra.uplo
```

## Low-level matrix operations

多くの場合、行列演算には、あらかじめ確保した出力ベクトルや行列を渡せるインプレース版があります。これは、重要なコードを最適化する際に、繰り返しのメモリ確保によるオーバーヘッドを避けるのに役立ちます。これらのインプレース演算には、Julia の一般的な慣例に従い、以下のように名前の末尾に `!` が付きます（例：`mul!`）。

```@docs
LinearAlgebra.mul!
LinearAlgebra.lmul!
LinearAlgebra.rmul!
LinearAlgebra.ldiv!
LinearAlgebra.rdiv!
```

## BLAS functions

Julia では（科学技術計算の多くと同様に）、密線形代数演算は [LAPACK library](https://www.netlib.org/lapack/) に基づいています。これはさらに、[BLAS](https://www.netlib.org/blas/) と呼ばれる線形代数の基本構成要素を基盤としています。あらゆるコンピューターアーキテクチャ向けに高度に最適化された BLAS 実装があり、高性能な線形代数ルーチンでは BLAS 関数を直接呼び出すと便利な場合があります。

`LinearAlgebra.BLAS` は、一部の BLAS 関数のラッパーを提供します。入力配列のいずれかを上書きする BLAS 関数の名前は、末尾が `'!'` になります。通常、BLAS 関数には [`Float32`](@ref)、[`Float64`](@ref)、[`ComplexF32`](@ref Complex)、[`ComplexF64`](@ref Complex) の各配列型に対して、4 つのメソッドが定義されています。

### [BLAS character arguments](@id stdlib-blas-chars)

多くの BLAS 関数では、引数を転置するか（`trans`）、行列のどちらの三角部分を参照するか（`uplo` または `ul`）、三角行列の対角成分がすべて 1 とみなせるか（`dA`）、あるいは行列積のどちら側に入力引数を置くか（`side`）を指定する引数を受け取ります。指定できる値は次のとおりです。

#### [Multiplication order](@id stdlib-blas-side)

| `side` | 意味                      |
|:------ |:----------------------- |
| `'L'`  | 行列と行列の演算で、引数を*左側*に置きます。 |
| `'R'`  | 行列と行列の演算で、引数を*右側*に置きます。 |

#### [Triangle referencing](@id stdlib-blas-uplo)

| `uplo`/`ul` | 意味                  |
|:----------- |:------------------- |
| `'U'`       | 行列の*上三角部分*だけを使用します。 |
| `'L'`       | 行列の*下三角部分*だけを使用します。 |

#### [Transposition operation](@id stdlib-blas-trans)

| `trans`/`tX` | 意味                     |
|:------------ |:---------------------- |
| `'N'`        | 入力行列 `X` は転置も共役もされません。 |
| `'T'`        | 入力行列 `X` を転置します。       |
| `'C'`        | 入力行列 `X` を共役転置します。     |

#### [Unit diagonal](@id stdlib-blas-diag)

| `diag`/`dX` | 意味                         |
|:----------- |:-------------------------- |
| `'N'`       | 行列 `X` の対角成分を読み取ります。       |
| `'U'`       | 行列 `X` の対角成分はすべて 1 とみなします。 |

```@docs
LinearAlgebra.BLAS
LinearAlgebra.BLAS.set_num_threads
LinearAlgebra.BLAS.get_num_threads
```

BLAS 関数は、最初に提案された時期、入力パラメーターの型、演算の複雑さに応じて、3 つのグループ（レベルとも呼ばれます）に分類できます。

### Level 1 BLAS functions

レベル 1 BLAS 関数は（[Lawson, 1979](https://dl.acm.org/doi/10.1145/355841.355847)）で初めて提案され、スカラーとベクトルの間の演算を定義します。

```@docs
# xROTG
# xROTMG
LinearAlgebra.BLAS.rot!
# xROTM
# xSWAP
LinearAlgebra.BLAS.scal!
LinearAlgebra.BLAS.scal
LinearAlgebra.BLAS.blascopy!
# xAXPY!
# xAXPBY!
LinearAlgebra.BLAS.dot
LinearAlgebra.BLAS.dotu
LinearAlgebra.BLAS.dotc
# xxDOT
LinearAlgebra.BLAS.nrm2
LinearAlgebra.BLAS.asum
LinearAlgebra.BLAS.iamax
```

### Level 2 BLAS functions

レベル 2 BLAS 関数は（[Dongarra, 1988](https://dl.acm.org/doi/10.1145/42288.42291)）で公開され、行列とベクトルの演算を定義します。

**ベクトルを返す**

```@docs
LinearAlgebra.BLAS.gemv!
LinearAlgebra.BLAS.gemv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemv(::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gbmv!
LinearAlgebra.BLAS.gbmv
LinearAlgebra.BLAS.hemv!
LinearAlgebra.BLAS.hemv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.hemv(::Any, ::Any, ::Any)
# hbmv!, hbmv
LinearAlgebra.BLAS.hpmv!
LinearAlgebra.BLAS.symv!
LinearAlgebra.BLAS.symv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symv(::Any, ::Any, ::Any)
LinearAlgebra.BLAS.sbmv!
LinearAlgebra.BLAS.sbmv(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.sbmv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.spmv!
LinearAlgebra.BLAS.trmv!
LinearAlgebra.BLAS.trmv
# xTBMV
# xTPMV
LinearAlgebra.BLAS.trsv!
LinearAlgebra.BLAS.trsv
# xTBSV
# xTPSV
```

**行列を返す**

```@docs
LinearAlgebra.BLAS.ger!
LinearAlgebra.BLAS.geru!
# xGERC
LinearAlgebra.BLAS.her!
# xHPR
# xHER2
# xHPR2
LinearAlgebra.BLAS.syr!
LinearAlgebra.BLAS.spr!
# xSYR2
# xSPR2
```

### Level 3 BLAS functions

レベル 3 BLAS 関数は（[Dongarra, 1990](https://dl.acm.org/doi/10.1145/77626.79170)）で公開され、行列と行列の演算を定義します。

```@docs
LinearAlgebra.BLAS.gemmt!
LinearAlgebra.BLAS.gemmt(::Any, ::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemmt(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemm!
LinearAlgebra.BLAS.gemm(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemm(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symm!
LinearAlgebra.BLAS.symm(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symm(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.hemm!
LinearAlgebra.BLAS.hemm(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.hemm(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.syrk!
LinearAlgebra.BLAS.syrk
LinearAlgebra.BLAS.herk!
LinearAlgebra.BLAS.herk
LinearAlgebra.BLAS.syr2k!
LinearAlgebra.BLAS.syr2k
LinearAlgebra.BLAS.her2k!
LinearAlgebra.BLAS.her2k
LinearAlgebra.BLAS.trmm!
LinearAlgebra.BLAS.trmm
LinearAlgebra.BLAS.trsm!
LinearAlgebra.BLAS.trsm
```

## [LAPACK functions](@id man-linalg-lapack-functions)

`LinearAlgebra.LAPACK` は、線形代数用の LAPACK 関数の一部をラップして提供します。入力配列のいずれかを上書きする関数の名前は、末尾が `'!'` になります。

通常、関数には [`Float64`](@ref)、[`Float32`](@ref)、`ComplexF64`、`ComplexF32` の各配列型に対して、4 つのメソッドが定義されています。

Julia が提供する LAPACK API は、今後変更される可能性があり、実際に変更されることがあります。この API はユーザー向けではないため、今後のリリースでこの特定の関数群をサポートまたは非推奨化することは保証されません。

```@docs
LinearAlgebra.LAPACK
LinearAlgebra.LAPACK.gbtrf!
LinearAlgebra.LAPACK.gbtrs!
LinearAlgebra.LAPACK.gebal!
LinearAlgebra.LAPACK.gebak!
LinearAlgebra.LAPACK.gebrd!
LinearAlgebra.LAPACK.gelqf!
LinearAlgebra.LAPACK.geqlf!
LinearAlgebra.LAPACK.geqrf!
LinearAlgebra.LAPACK.geqp3!
LinearAlgebra.LAPACK.gerqf!
LinearAlgebra.LAPACK.geqrt!
LinearAlgebra.LAPACK.geqrt3!
LinearAlgebra.LAPACK.getrf!
LinearAlgebra.LAPACK.tzrzf!
LinearAlgebra.LAPACK.ormrz!
LinearAlgebra.LAPACK.gels!
LinearAlgebra.LAPACK.gesv!
LinearAlgebra.LAPACK.getrs!
LinearAlgebra.LAPACK.getri!
LinearAlgebra.LAPACK.gesvx!
LinearAlgebra.LAPACK.gelsd!
LinearAlgebra.LAPACK.gelsy!
LinearAlgebra.LAPACK.gglse!
LinearAlgebra.LAPACK.geev!
LinearAlgebra.LAPACK.gesdd!
LinearAlgebra.LAPACK.gesvd!
LinearAlgebra.LAPACK.ggsvd!
LinearAlgebra.LAPACK.ggsvd3!
LinearAlgebra.LAPACK.geevx!
LinearAlgebra.LAPACK.ggev!
LinearAlgebra.LAPACK.ggev3!
LinearAlgebra.LAPACK.gtsv!
LinearAlgebra.LAPACK.gttrf!
LinearAlgebra.LAPACK.gttrs!
LinearAlgebra.LAPACK.orglq!
LinearAlgebra.LAPACK.orgqr!
LinearAlgebra.LAPACK.orgql!
LinearAlgebra.LAPACK.orgrq!
LinearAlgebra.LAPACK.ormlq!
LinearAlgebra.LAPACK.ormqr!
LinearAlgebra.LAPACK.ormql!
LinearAlgebra.LAPACK.ormrq!
LinearAlgebra.LAPACK.gemqrt!
LinearAlgebra.LAPACK.posv!
LinearAlgebra.LAPACK.potrf!
LinearAlgebra.LAPACK.potri!
LinearAlgebra.LAPACK.potrs!
LinearAlgebra.LAPACK.pstrf!
LinearAlgebra.LAPACK.ptsv!
LinearAlgebra.LAPACK.pttrf!
LinearAlgebra.LAPACK.pttrs!
LinearAlgebra.LAPACK.trtri!
LinearAlgebra.LAPACK.trtrs!
LinearAlgebra.LAPACK.trcon!
LinearAlgebra.LAPACK.trevc!
LinearAlgebra.LAPACK.trrfs!
LinearAlgebra.LAPACK.stev!
LinearAlgebra.LAPACK.stebz!
LinearAlgebra.LAPACK.stegr!
LinearAlgebra.LAPACK.stein!
LinearAlgebra.LAPACK.syconv!
LinearAlgebra.LAPACK.sysv!
LinearAlgebra.LAPACK.sytrf!
LinearAlgebra.LAPACK.sytri!
LinearAlgebra.LAPACK.sytrs!
LinearAlgebra.LAPACK.hesv!
LinearAlgebra.LAPACK.hetrf!
LinearAlgebra.LAPACK.hetri!
LinearAlgebra.LAPACK.hetrs!
LinearAlgebra.LAPACK.syev!
LinearAlgebra.LAPACK.syevr!
LinearAlgebra.LAPACK.syevd!
LinearAlgebra.LAPACK.sygvd!
LinearAlgebra.LAPACK.bdsqr!
LinearAlgebra.LAPACK.bdsdc!
LinearAlgebra.LAPACK.gecon!
LinearAlgebra.LAPACK.gehrd!
LinearAlgebra.LAPACK.orghr!
LinearAlgebra.LAPACK.gees!
LinearAlgebra.LAPACK.gges!
LinearAlgebra.LAPACK.gges3!
LinearAlgebra.LAPACK.trexc!
LinearAlgebra.LAPACK.trsen!
LinearAlgebra.LAPACK.tgsen!
LinearAlgebra.LAPACK.trsyl!
LinearAlgebra.LAPACK.hseqr!
```

## Developer Documentation

```@docs
LinearAlgebra.matprod_dest
LinearAlgebra.haszero
```

```@meta
DocTestSetup = nothing
```
