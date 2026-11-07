```julia
rest(iter, state)
```

`iter`と同じ要素を返すイテレータ。ただし、指定された`state`から開始します。この状態は、`iterate(iter[, state])`を1回以上呼び出すことで到達できる状態でなければなりません。

関連項目: [`Iterators.drop`](@ref)、[`Iterators.peel`](@ref)、[`Base.rest`](@ref)。

# Examples

```jldoctest
julia> iter = [1,2,3,4];

julia> val, state = iterate(iter)
(1, 2)

julia> collect(Iterators.rest(iter, state))
3-element Vector{Int64}:
 2
 3
 4
```
