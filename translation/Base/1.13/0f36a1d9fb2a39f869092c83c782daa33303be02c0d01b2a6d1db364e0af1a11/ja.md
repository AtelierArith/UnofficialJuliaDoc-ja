```julia
filter(f, a)
```

`a`から、`f`が`false`である要素を取り除いたコレクションのコピーを返します。この関数`f`には、引数を1つ渡します。

!!! compat "Julia 1.4"
    `a`をタプルとしてサポートするには、Julia 1.4以降が必要です。


関連項目: [`filter!`](@ref)、[`Iterators.filter`](@ref)。

# Examples

```jldoctest
julia> a = 1:10
1:10

julia> filter(isodd, a)
5-element Vector{Int64}:
 1
 3
 5
 7
 9
```
