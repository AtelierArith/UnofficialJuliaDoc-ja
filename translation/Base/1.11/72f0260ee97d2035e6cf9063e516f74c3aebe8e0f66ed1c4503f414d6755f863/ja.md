```
vcat(A...)
```

配列または数値を垂直に連結します。 [`cat`](@ref)`(A...; dims=1)` と同等であり、構文 `[a; b; c]` とも同じです。

大きな配列のベクトルを連結する場合、`reduce(vcat, A)` は `A isa AbstractVector{<:AbstractVecOrMat}` のときに効率的な方法を呼び出し、ペアワイズで処理するのではありません。

他にも [`hcat`](@ref)、[`Iterators.flatten`](@ref)、[`stack`](@ref) を参照してください。

# 例

```jldoctest
julia> v = vcat([1,2], [3,4])
4-element Vector{Int64}:
 1
 2
 3
 4

julia> v == vcat(1, 2, [3,4])  # 数値を受け入れます
true

julia> v == [1; 2; [3,4]]  # 同じ操作のための構文
true

julia> summary(ComplexF64[1; 2; [3,4]])  # 要素型を指定するための構文
"4-element Vector{ComplexF64}"

julia> vcat(range(1, 2, length=3))  # 遅延範囲を収集します
3-element Vector{Float64}:
 1.0
 1.5
 2.0

julia> two = ([10, 20, 30]', Float64[4 5 6; 7 8 9])  # 行ベクトルと行列
([10 20 30], [4.0 5.0 6.0; 7.0 8.0 9.0])

julia> vcat(two...)
3×3 Matrix{Float64}:
 10.0  20.0  30.0
  4.0   5.0   6.0
  7.0   8.0   9.0

julia> vs = [[1, 2], [3, 4], [5, 6]];

julia> reduce(vcat, vs)  # vcat(vs...) よりも効率的です
6-element Vector{Int64}:
 1
 2
 3
 4
 5
 6

julia> ans == collect(Iterators.flatten(vs))
true
```
