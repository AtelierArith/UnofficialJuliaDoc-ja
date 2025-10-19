```julia
Diagonal(V::AbstractVector)
```

`V`を対角成分とする遅延行列を構築します。

遅延単位行列`I`については[`UniformScaling`](@ref)を、密行列を作成するための[`diagm`](@ref)を、対角要素を抽出するための[`diag`](@ref)を参照してください。

# 例

```jldoctest
julia> d = Diagonal([1, 10, 100])
3×3 Diagonal{Int64, Vector{Int64}}:
 1   ⋅    ⋅
 ⋅  10    ⋅
 ⋅   ⋅  100

julia> diagm([7, 13])
2×2 Matrix{Int64}:
 7   0
 0  13

julia> ans + I
2×2 Matrix{Int64}:
 8   0
 0  14

julia> I(2)
2×2 Diagonal{Bool, Vector{Bool}}:
 1  ⋅
 ⋅  1
```

!!! note
    1列の行列はベクトルのようには扱われず、代わりに1要素の`diag(A)`を抽出する`Diagonal(A::AbstractMatrix)`メソッドが呼び出されます:


```jldoctest
julia> A = transpose([7.0 13.0])
2×1 transpose(::Matrix{Float64}) with eltype Float64:
  7.0
 13.0

julia> Diagonal(A)
1×1 Diagonal{Float64, Vector{Float64}}:
 7.0
```
