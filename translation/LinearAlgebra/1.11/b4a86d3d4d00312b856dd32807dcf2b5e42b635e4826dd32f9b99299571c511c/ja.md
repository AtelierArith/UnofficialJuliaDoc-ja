```
hessenberg(A) -> Hessenberg
```

行列 `A` のヘッセンベルグ分解を計算し、`Hessenberg` オブジェクトを返します。`F` が因子化オブジェクトである場合、ユニタリ行列には `F.Q`（型 `LinearAlgebra.HessenbergQ`）でアクセスでき、ヘッセンベルグ行列には `F.H`（型 [`UpperHessenberg`](@ref)）でアクセスできます。どちらも `Matrix(F.H)` または `Matrix(F.Q)` を使用して通常の行列に変換できます。

`A` が [`Hermitian`](@ref) または実 [`Symmetric`](@ref) である場合、ヘッセンベルグ分解は実対称トリディアゴナル行列を生成し、`F.H` は型 [`SymTridiagonal`](@ref) になります。

シフト因子化 `A+μI = Q (H+μI) Q'` は、[`UniformScaling`](@ref) オブジェクト [`I`](@ref) を使用して `F + μ*I` によって効率的に構築できます。これにより、共有ストレージと修正されたシフトを持つ新しい `Hessenberg` オブジェクトが作成されます。与えられた `F` のシフトは `F.μ` によって取得されます。これは、`F` が作成された後に、異なる `μ` および/または `b` に対して複数のシフト解 `(F + μ*I) \ b` を効率的に実行できるため便利です。

分解を反復することで、因子 `F.Q, F.H, F.μ` が得られます。

# 例

```julia-repl
julia> A = [4. 9. 7.; 4. 4. 1.; 4. 3. 2.]
3×3 Matrix{Float64}:
 4.0  9.0  7.0
 4.0  4.0  1.0
 4.0  3.0  2.0

julia> F = hessenberg(A)
Hessenberg{Float64, UpperHessenberg{Float64, Matrix{Float64}}, Matrix{Float64}, Vector{Float64}, Bool}
Q factor: 3×3 LinearAlgebra.HessenbergQ{Float64, Matrix{Float64}, Vector{Float64}, false}
H factor:
3×3 UpperHessenberg{Float64, Matrix{Float64}}:
  4.0      -11.3137       -1.41421
 -5.65685    5.0           2.0
   ⋅        -8.88178e-16   1.0

julia> F.Q * F.H * F.Q'
3×3 Matrix{Float64}:
 4.0  9.0  7.0
 4.0  4.0  1.0
 4.0  3.0  2.0

julia> q, h = F; # 反復による分解

julia> q == F.Q && h == F.H
true
```
