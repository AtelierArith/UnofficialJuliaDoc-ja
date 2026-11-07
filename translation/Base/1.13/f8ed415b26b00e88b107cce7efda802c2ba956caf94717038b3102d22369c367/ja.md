```julia
popat!(a::Vector, i::Integer, [default])
```

指定された`i`の位置にある要素を削除して返します。後続の要素は、空いた位置を埋めるように移動します。`a`に対して`i`が有効なインデックスでない場合、`default`が指定されていなければエラーをスローし、指定されていれば`default`を返します。

関連項目: [`pop!`](@ref)、[`popfirst!`](@ref)、[`deleteat!`](@ref)、[`splice!`](@ref)。

!!! compat "Julia 1.5"
    この関数はJulia 1.5以降で利用できます。


# Examples

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
