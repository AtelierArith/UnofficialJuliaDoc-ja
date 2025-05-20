```
union(s, itrs...)
∪(s, itrs...)
```

すべての引数からの異なる要素を含むオブジェクトを構築します。

最初の引数は、返されるコンテナの種類を制御します。これが配列である場合、要素が最初に現れる順序を維持します。

Unicode `∪` は、Julia REPL で `\cup` と入力してタブを押すことで、また多くのエディタで入力できます。これは中置演算子であり、`s ∪ itr` のように使用できます。

関連項目としては [`unique`](@ref)、[`intersect`](@ref)、[`isdisjoint`](@ref)、[`vcat`](@ref)、[`Iterators.flatten`](@ref) があります。

# 例

```jldoctest
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
