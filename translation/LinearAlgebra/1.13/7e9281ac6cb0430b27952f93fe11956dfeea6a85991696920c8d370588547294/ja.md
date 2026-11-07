```julia
hessenberg(A) -> Hessenberg
```

`A` のヘッセンベルグ分解を計算し、`Hessenberg` オブジェクトを返します。`F` が分解オブジェクトの場合、ユニタリ行列は `F.Q`（型は `LinearAlgebra.HessenbergQ`）で、ヘッセンベルグ行列は `F.H`（型は [`UpperHessenberg`](@ref)）で取得できます。どちらも `Matrix(F.H)` または `Matrix(F.Q)` を使って通常の行列に変換できます。

`A` が [`Hermitian`](@ref) または実数型の [`Symmetric`](@ref) の場合、ヘッセンベルグ分解によって実対称三重対角行列が得られ、`F.H` の型は [`SymTridiagonal`](@ref) になります。

シフト付き分解 `A+μI = Q (H+μI) Q'` は、[`UniformScaling`](@ref) オブジェクト [`I`](@ref) を使って `F + μ*I` で効率よく構築できます。この操作では、ストレージを共有し、シフトを変更した新しい `Hessenberg` オブジェクトが作成されます。指定した `F` のシフトは、`F.μ` で取得できます。これは、`F` の作成後、異なる `μ` や `b`（またはその両方）に対する複数のシフト付き求解 `(F + μ*I) \ b` を効率よく実行できるため便利です。

分解を反復すると、因子 `F.Q, F.H, F.μ` が得られます。

# Examples

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

julia> q, h = F; # destructuring via iteration

julia> q == F.Q && h == F.H
true
```
