```julia
eigen(A, B; sortby) -> GeneralizedEigen
```

`A` と `B` の一般化固有値分解を計算し、一般化固有値を `F.values` に、一般化固有ベクトルを行列 `F.vectors` の列に格納した [`GeneralizedEigen`](@ref) 分解オブジェクト `F` を返します。これは、`A, B` が行列、`x` が固有ベクトル、`λ` が固有値である、次の形式の一般化固有値問題を解くことに相当します: `Ax =  λBx`。（`k` 番目の一般化固有ベクトルは、スライス `F.vectors[:, k]` から取得できます。）

この分解を反復すると、成分 `F.values` と `F.vectors` が得られます。

デフォルトでは、固有値と固有ベクトルは `(real(λ),imag(λ))` の辞書順でソートされます。別の比較関数 `by(λ)` を `sortby` に渡すことも、`sortby=nothing` を渡して固有値を任意の順序のままにすることもできます。

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

julia> F = eigen(A, B);

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
