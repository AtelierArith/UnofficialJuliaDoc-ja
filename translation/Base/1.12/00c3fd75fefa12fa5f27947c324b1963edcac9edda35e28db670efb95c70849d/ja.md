```julia
popat!(a::Vector, i::Integer, [default])
```

指定された `i` のアイテムを削除し、それを返します。次のアイテムは、結果として生じる隙間を埋めるためにシフトされます。`i` が `a` の有効なインデックスでない場合、`default` を返すか、`default` が指定されていない場合はエラーをスローします。

関連項目: [`pop!`](@ref), [`popfirst!`](@ref), [`deleteat!`](@ref), [`splice!`](@ref).

!!! compat "Julia 1.5"
    この関数は Julia 1.5 以降で利用可能です。


# 例

```jldoctest
julia> a = [4, 3, 2, 1]; popat!(a, 2)
3

julia> a
3-element Vector{Int64}:
 4
 2
 1

julia> popat!(a, 4, missing)
missing

julia> popat!(a, 4)
ERROR: BoundsError: attempt to access 3-element Vector{Int64} at index [4]
[...]
```
