```
lu(A, pivot = RowMaximum(); check = true, allowsingular = false) -> F::LU
```

行列 `A` の LU 分解を計算します。

`check = true` の場合、分解が失敗した場合にエラーがスローされます。`check = false` の場合、分解の有効性を確認する責任はユーザーにあります（[`issuccess`](@ref) を介して）。

デフォルトでは、`check = true` の場合、分解が有効な因子を生成しても、上三角因子 `U` がランク欠損の場合にもエラーがスローされます。これは `allowsingular = true` を渡すことで変更できます。

ほとんどの場合、`A` が要素型 `T` を持ち、`+`、`-`、`*` および `/` をサポートする `AbstractMatrix{T}` のサブタイプ `S` である場合、戻り値の型は `LU{T,S{T}}` です。

一般に、LU 分解は行列の行の順序を入れ替えることを含みます（以下に説明する `F.p` 出力に対応）、これは「ピボット」と呼ばれます（これは「ピボット」を含む行を選択することに対応し、`F.U` の対角成分です）。次のいずれかのピボット戦略をオプションの `pivot` 引数を介して選択できます：

  * `RowMaximum()`（デフォルト）：標準のピボット戦略；ピボットは、残りの因子化される行の中で最大絶対値を持つ要素に対応します。このピボット戦略は、要素型が [`abs`](@ref) および [`<`](@ref) をサポートすることを要求します。（これは一般に浮動小数点行列に対して唯一の数値的に安定したオプションです。）
  * `RowNonZero()`: ピボットは、残りの因子化される行の中で最初の非ゼロ要素に対応します。（これは手計算での典型的な選択に対応し、`abs` や `<` をサポートしないより一般的な代数数型にも便利です。）
  * `NoPivot()`: ピボットをオフにします（`allowsingular = true` の場合でも、ピボット位置でゼロエントリに遭遇すると失敗します）。

分解 `F` の個々のコンポーネントには [`getproperty`](@ref) を介してアクセスできます：

| コンポーネント | 説明                |
|:------- |:----------------- |
| `F.L`   | `LU` の `L`（下三角）部分 |
| `F.U`   | `LU` の `U`（上三角）部分 |
| `F.p`   | （右）置換 `Vector`    |
| `F.P`   | （右）置換 `Matrix`    |

分解を反復すると、コンポーネント `F.L`、`F.U`、および `F.p` が得られます。

`F` と `A` の関係は次の通りです。

`F.L*F.U == A[F.p, :]`

`F` はさらに次の関数をサポートします：

| サポートされる関数           | `LU` | `LU{T,Tridiagonal{T}}` |
|:------------------- |:---- |:---------------------- |
| [`/`](@ref)         | ✓    |                        |
| [`\`](@ref)         | ✓    | ✓                      |
| [`inv`](@ref)       | ✓    | ✓                      |
| [`det`](@ref)       | ✓    | ✓                      |
| [`logdet`](@ref)    | ✓    | ✓                      |
| [`logabsdet`](@ref) | ✓    | ✓                      |
| [`size`](@ref)      | ✓    | ✓                      |

!!! compat "Julia 1.11"
    `allowsingular` キーワード引数は Julia 1.11 で追加されました。


# 例

```jldoctest
julia> A = [4 3; 6 3]
2×2 Matrix{Int64}:
 4  3
 6  3

julia> F = lu(A)
LU{Float64, Matrix{Float64}, Vector{Int64}}
L factor:
2×2 Matrix{Float64}:
 1.0       0.0
 0.666667  1.0
U factor:
2×2 Matrix{Float64}:
 6.0  3.0
 0.0  1.0

julia> F.L * F.U == A[F.p, :]
true

julia> l, u, p = lu(A); # 反復を介した分解

julia> l == F.L && u == F.U && p == F.p
true

julia> lu([1 2; 1 2], allowsingular = true)
LU{Float64, Matrix{Float64}, Vector{Int64}}
L factor:
2×2 Matrix{Float64}:
 1.0  0.0
 1.0  1.0
U factor (rank-deficient):
2×2 Matrix{Float64}:
 1.0  2.0
 0.0  0.0
```
