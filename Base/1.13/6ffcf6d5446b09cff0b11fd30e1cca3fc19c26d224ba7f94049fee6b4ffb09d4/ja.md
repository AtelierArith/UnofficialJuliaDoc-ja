```julia
findall(f::Function, A)
```

`A` の要素のうち、`f(A[I])` が `true` を返すものについて、そのインデックスまたはキーのベクトル `I` を返します。`A` に該当する要素がない場合は、空の配列を返します。

インデックスまたはキーの型は、[`keys(A)`](@ref) および [`pairs(A)`](@ref) が返すものと同じです。

# Examples

```jldoctest
julia> x = [1, 3, 4]
3-element Vector{Int64}:
 1
 3
 4

julia> findall(isodd, x)
2-element Vector{Int64}:
 1
 2

julia> A = [1 2 0; 3 4 0]
2×3 Matrix{Int64}:
 1  2  0
 3  4  0
julia> findall(isodd, A)
2-element Vector{CartesianIndex{2}}:
 CartesianIndex(1, 1)
 CartesianIndex(2, 1)

julia> findall(!iszero, A)
4-element Vector{CartesianIndex{2}}:
 CartesianIndex(1, 1)
 CartesianIndex(2, 1)
 CartesianIndex(1, 2)
 CartesianIndex(2, 2)

julia> d = Dict(:A => 10, :B => -1, :C => 0)
Dict{Symbol, Int64} with 3 entries:
  :A => 10
  :B => -1
  :C => 0

julia> findall(≥(0), d)
2-element Vector{Symbol}:
 :A
 :C

```
