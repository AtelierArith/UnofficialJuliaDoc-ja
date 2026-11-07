```julia
nth(itr, n::Integer)
```

反復可能なコレクションの`n`番目の要素を取得します。要素が存在しない場合は、`BoundsError`[@ref]をスローします。`Stateful`[@ref]イテレータがあれば、そのイテレータを進めます。

関連項目: [`first`](@ref)、[`last`](@ref)

# Examples

```jldoctest
julia> Iterators.nth(2:2:10, 4)
8

julia> Iterators.nth(reshape(1:30, (5,6)), 6)
6

julia> stateful = Iterators.Stateful(1:10); Iterators.nth(stateful, 7)
7

julia> first(stateful)
8
```

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13以降が必要です。

