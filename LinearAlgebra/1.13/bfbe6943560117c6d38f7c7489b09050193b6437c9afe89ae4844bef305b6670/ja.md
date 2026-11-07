```julia
lu(A, pivot = RowMaximum(); check = true, allowsingular = false) -> F::LU
```

`A` の LU 分解を計算します。

`check = true` の場合、分解に失敗するとエラーがスローされます。`check = false` の場合、分解が有効かどうか（[`issuccess`](@ref) を使って）確認する責任はユーザーにあります。

デフォルトでは、`check = true` の場合、分解によって有効な因子が得られても、上三角因子 `U` がランク落ちしているとエラーがスローされます。これは `allowsingular = true` を渡すことで変更できます。

多くの場合、`A` が、要素型 `T` を持つ `AbstractMatrix{T}` のサブタイプ `S` であり、その要素型が `+`、`-`、`*`、`/` をサポートする場合、戻り値の型は `LU{T,S{T}}` です。

一般に、LU 分解では行列の行を並べ替えます（これは以下で説明する `F.p` 出力に対応します）。この操作は「ピボット選択」と呼ばれます（`F.U` の対角要素である「ピボット」を含む行を選ぶことに由来します）。省略可能な `pivot` 引数で、次のいずれかのピボット選択方式を指定できます。

  * `RowMaximum()`（デフォルト）：標準的なピボット選択方式です。ピボットには、これから分解する残りの行にある要素のうち、絶対値が最大のものを選びます。この方式では、要素型が [`abs`](@ref) と [`<`](@ref) もサポートしている必要があります。（浮動小数点行列では、通常、数値的に安定した唯一の選択肢です。）
  * `RowNonZero()`：ピボットには、これから分解する残りの行にある最初の非ゼロ要素を選びます。（手計算で一般的に使われる選び方であり、[`iszero`](@ref) はサポートするものの、`abs` や `<` はサポートしない、より一般的な代数的数の型にも有用です。）
  * `NoPivot()`：ピボット選択を無効にします。ピボット位置の要素がゼロの場合、`allowsingular = true` であっても失敗します。

分解 `F` の各成分には、[`getproperty`](@ref) からアクセスできます。

| 成分    | 説明                |
|:----- |:----------------- |
| `F.L` | `LU` の `L`（下三角）部分 |
| `F.U` | `LU` の `U`（上三角）部分 |
| `F.p` | （右）置換 `Vector`    |
| `F.P` | （右）置換 `Matrix`    |

分解を反復すると、成分 `F.L`、`F.U`、`F.p` が順に得られます。

`F` と `A` の関係は次のとおりです。

`F.L*F.U == A[F.p, :]`

`F` は、さらに次の関数をサポートします。

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


# Examples

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

julia> l, u, p = lu(A); # destructuring via iteration

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
