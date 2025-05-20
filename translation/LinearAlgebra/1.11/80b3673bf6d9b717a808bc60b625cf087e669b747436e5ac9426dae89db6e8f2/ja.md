```
eigen(A; permute::Bool=true, scale::Bool=true, sortby) -> Eigen
```

行列 `A` の固有値分解を計算し、固有値を `F.values` に、固有ベクトルを行列 `F.vectors` の列に含む [`Eigen`](@ref) 因子化オブジェクト `F` を返します。これは、`Ax =  λx` の形の固有値問題を解くことに対応し、ここで `A` は行列、`x` は固有ベクトル、`λ` は固有値です。(`k` 番目の固有ベクトルはスライス `F.vectors[:, k]` から取得できます。)

分解を反復することで、成分 `F.values` と `F.vectors` を得ることができます。

`Eigen` オブジェクトに対して利用可能な関数は次のとおりです: [`inv`](@ref), [`det`](@ref), および [`isposdef`](@ref)。

一般的な非対称行列に対しては、固有ベクトル計算の前に行列がどのようにバランスされるかを指定することが可能です。オプション `permute=true` は行列を上三角行列に近づけるように並べ替え、`scale=true` は行列を対角要素でスケーリングして行と列のノルムをより等しくします。デフォルトは両方のオプションが `true` です。

デフォルトでは、固有値とベクトルは `(real(λ),imag(λ))` によって辞書式にソートされます。異なる比較関数 `by(λ)` を `sortby` に渡すことができ、または `sortby=nothing` を渡して固有値を任意の順序のままにすることもできます。一部の特別な行列タイプ（例: [`Diagonal`](@ref) や [`SymTridiagonal`](@ref)）は独自のソート規則を実装しており、`sortby` キーワードを受け付けない場合があります。

# 例

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

julia> vals, vecs = F; # 反復による分解

julia> vals == F.values && vecs == F.vectors
true
```
