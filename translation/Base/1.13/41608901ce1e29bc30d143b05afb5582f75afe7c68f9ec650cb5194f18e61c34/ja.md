```julia
union(s, itrs...)
∪(s, itrs...)
```

すべての引数に含まれる、重複のない要素からなるオブジェクトを構築します。

返されるコンテナーの種類は、最初の引数によって決まります。最初の引数が配列の場合、要素が最初に現れた順序が保たれます。

Unicode の `∪` は、Julia REPL や多くのエディターで `\cup` と入力してから Tab キーを押すと入力できます。これは中置演算子であり、`s ∪ itr` を可能にします。

関連項目: [`unique`](@ref)、[`intersect`](@ref)、[`isdisjoint`](@ref)、[`vcat`](@ref)、[`Iterators.flatten`](@ref)。

# Examples

```jldoctest; filter = r"^\s+\d$"m
julia> union([1, 2], [3])
3-element Vector{Int64}:
 1
 2
 3

julia> union([4 2 3 4 4], 1:3, 3.0)
4-element Vector{Float64}:
 4.0
 2.0
 3.0
 1.0

julia> (0, 0.0) ∪ (-0.0, NaN)
3-element Vector{Real}:
   0
  -0.0
 NaN

julia> union(Set([1, 2]), 2:3)
Set{Int64} with 3 elements:
  2
  3
  1
```
