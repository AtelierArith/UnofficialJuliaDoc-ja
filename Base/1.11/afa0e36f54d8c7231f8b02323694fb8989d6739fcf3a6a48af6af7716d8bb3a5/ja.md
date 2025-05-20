```
intersect(s, itrs...)
∩(s, itrs...)
```

すべての引数に出現する要素を含む集合を構築します。

最初の引数は、返されるコンテナの種類を制御します。これが配列である場合、要素が最初に出現する順序を維持します。

Unicode `∩` は、Julia REPLで `\cap` と入力してタブを押すことで入力できます。また、多くのエディタでも同様です。これは中置演算子であり、`s ∩ itr` のように使用できます。

他にも [`setdiff`](@ref)、[`isdisjoint`](@ref)、[`issubset`](@ref Base.issubset)、[`issetequal`](@ref) を参照してください。

!!! compat "Julia 1.8"
    Julia 1.8以降、intersectは2つの入力の型昇格されたeltypeのeltypeを持つ結果を返します。


# 例

```jldoctest
julia> intersect([1, 2, 3], [3, 4, 5])
1-element Vector{Int64}:
 3

julia> intersect([1, 4, 4, 5, 6], [6, 4, 6, 7, 8])
2-element Vector{Int64}:
 4
 6

julia> intersect(1:16, 7:99)
7:16

julia> (0, 0.0) ∩ (-0.0, 0)
1-element Vector{Real}:
 0

julia> intersect(Set([1, 2]), BitSet([2, 3]), 1.0:10.0)
Set{Float64} with 1 element:
  2.0
```
