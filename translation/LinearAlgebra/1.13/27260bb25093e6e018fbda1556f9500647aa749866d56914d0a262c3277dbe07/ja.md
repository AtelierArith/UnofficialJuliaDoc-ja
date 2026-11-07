```julia
GeneralizedEigen <: Factorization
```

`A`と`B`の一般化固有値分解／スペクトル分解を表す行列因子分解型です。2つの行列引数を指定して呼び出した場合に、対応する行列因子分解関数である[`eigen`](@ref)が返す型です。

`F::GeneralizedEigen`が因子分解オブジェクトの場合、固有値は`F.values`で取得でき、固有ベクトルは行列`F.vectors`の列として得られます。（`k`番目の固有ベクトルは、スライス`F.vectors[:, k]`から取得できます。）

この分解を反復処理すると、成分`F.values`と`F.vectors`が生成されます。

# Examples

```jldoctest
julia> A = [1 0; 0 -1]
2×2 Matrix{Int64}:
 1   0
 0  -1

julia> B = [0 1; 1 0]
2×2 Matrix{Int64}:
 0  1
 1  0

julia> F = eigen(A, B)
GeneralizedEigen{ComplexF64, ComplexF64, Matrix{ComplexF64}, Vector{ComplexF64}}
values:
2-element Vector{ComplexF64}:
 0.0 - 1.0im
 0.0 + 1.0im
vectors:
2×2 Matrix{ComplexF64}:
  0.0+1.0im   0.0-1.0im
 -1.0+0.0im  -1.0-0.0im

julia> F.values
2-element Vector{ComplexF64}:
 0.0 - 1.0im
 0.0 + 1.0im

julia> F.vectors
2×2 Matrix{ComplexF64}:
  0.0+1.0im   0.0-1.0im
 -1.0+0.0im  -1.0-0.0im

julia> vals, vecs = F; # destructuring via iteration

julia> vals == F.values && vecs == F.vectors
true
```
