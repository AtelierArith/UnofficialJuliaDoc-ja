```
eigen(A, B; sortby) -> GeneralizedEigen
```

行列 `A` と `B` の一般化固有値分解を計算し、一般化固有値を `F.values` に、一般化固有ベクトルを行列 `F.vectors` の列に含む [`GeneralizedEigen`](@ref) 因子化オブジェクト `F` を返します。これは、一般化固有値問題 `Ax =  λBx` を解くことに対応し、ここで `A, B` は行列、`x` は固有ベクトル、`λ` は固有値です。 (`k` 番目の一般化固有ベクトルはスライス `F.vectors[:, k]` から取得できます。)

分解を反復することで、成分 `F.values` と `F.vectors` を得ることができます。

デフォルトでは、固有値とベクトルは `(real(λ),imag(λ))` によって辞書式にソートされます。異なる比較関数 `by(λ)` を `sortby` に渡すことができ、または `sortby=nothing` を渡して固有値を任意の順序のままにすることもできます。

# 例

```jldoctest
julia> A = [1 0; 0 -1]
2×2 Matrix{Int64}:
 1   0
 0  -1

julia> B = [0 1; 1 0]
2×2 Matrix{Int64}:
 0  1
 1  0

julia> F = eigen(A, B);

julia> F.values
2-element Vector{ComplexF64}:
 0.0 - 1.0im
 0.0 + 1.0im

julia> F.vectors
2×2 Matrix{ComplexF64}:
  0.0+1.0im   0.0-1.0im
 -1.0+0.0im  -1.0-0.0im

julia> vals, vecs = F; # 反復による分解

julia> vals == F.values && vecs == F.vectors
true
```
