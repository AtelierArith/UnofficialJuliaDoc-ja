```julia
nth(n::Integer)
```

渡された任意のイテレータから、`n` 番目の要素を取得する関数を返します。`Base.Fix2(nth, n)` または `itr -> nth(itr, n)` と同等です。

関連項目: [`nth`](@ref)、[`Base.Fix2`](@ref)

# Examples

```jldoctest
julia> fifth_element = Iterators.nth(5)
(::Base.Fix2{typeof(Base.Iterators.nth), Int64}) (generic function with 2 methods)

julia> fifth_element(reshape(1:30, (5,6)))
5

julia> map(fifth_element, ("Willis", "Jovovich", "Oldman"))
('i', 'v', 'a')
```
