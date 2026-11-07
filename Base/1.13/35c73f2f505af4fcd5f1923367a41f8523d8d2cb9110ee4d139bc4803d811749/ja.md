```julia
intersect(s, itrs...)
∩(s, itrs...)
```

すべての引数に含まれる要素からなる集合を構築します。

返されるコンテナーの種類は、最初の引数によって決まります。最初の引数が配列の場合、要素が最初に現れた順序が保たれます。

Unicode `∩` は、Julia REPL や多くのエディターで `\cap` と入力して Tab キーを押すと入力できます。これは中置演算子であり、`s ∩ itr` を可能にします。

関連項目: [`setdiff`](@ref)、[`isdisjoint`](@ref)、[`issubset`](@ref Base.issubset)、[`issetequal`](@ref)。

!!! compat "Julia 1.8"
    Julia 1.8 以降、intersect は、2 つの入力の要素型を型昇格した型を要素型とする結果を返します。


# Examples

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
