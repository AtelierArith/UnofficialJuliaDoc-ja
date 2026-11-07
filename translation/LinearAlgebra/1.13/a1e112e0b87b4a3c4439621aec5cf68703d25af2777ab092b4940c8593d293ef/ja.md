```julia
eigen(A; permute::Bool=true, scale::Bool=true, sortby) -> Eigen
```

`A` の固有値分解を計算し、固有値を `F.values` に、正規化された固有ベクトルを行列 `F.vectors` の列に格納した、[`Eigen`](@ref) 分解オブジェクト `F` を返します。これは、`A` が行列、`x` が固有ベクトル、`λ` が固有値である、`Ax =  λx` の形の固有値問題を解くことに相当します。（`k` 番目の固有ベクトルは、スライス `F.vectors[:, k]` から取得できます。）

この分解を反復すると、成分 `F.values` と `F.vectors` が得られます。

`Eigen` オブジェクトでは、次の関数を利用できます：[`inv`](@ref)、[`det`](@ref)、[`isposdef`](@ref)。

一般の非対称行列では、固有ベクトルの計算前に行列をどのようにバランス調整するかを指定できます。オプション `permute=true` は行列を置換して上三角行列に近づけ、`scale=true` は行列を対角要素でスケーリングして、行と列のノルムをより均等にします。どちらのオプションも、デフォルトは `true` です。

デフォルトでは、固有値と固有ベクトルは `(real(λ),imag(λ))` による辞書式順序で並べ替えられます。別の比較関数 `by(λ)` を `sortby` に渡すことも、`sortby=nothing` を渡して固有値を任意の順序のままにすることもできます。[`Diagonal`](@ref) や [`SymTridiagonal`](@ref) など、一部の特殊な行列型は独自の並べ替え規則を実装しており、キーワード `sortby` を受け付けない場合があります。

# Examples

```jldoctest
julia> F = eigen([1.0 0.0 0.0; 0.0 3.0 0.0; 0.0 0.0 18.0])
Eigen{Float64, Float64, Matrix{Float64}, Vector{Float64}}
values:
3-element Vector{Float64}:
  1.0
  3.0
 18.0
vectors:
3×3 Matrix{Float64}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> F.values
3-element Vector{Float64}:
  1.0
  3.0
 18.0

julia> F.vectors
3×3 Matrix{Float64}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> vals, vecs = F; # destructuring via iteration

julia> vals == F.values && vecs == F.vectors
true
```
