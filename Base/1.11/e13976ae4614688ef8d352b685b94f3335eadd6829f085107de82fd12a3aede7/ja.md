```
oneunit(x::T)
oneunit(T::Type)
```

引数の型が `T` であるか、型が渡された場合は引数である `T(one(x))` を返します。これは次元を持つ量に対する [`one`](@ref) とは異なります：`one` は次元を持たない（乗法的単位元）ですが、`oneunit` は次元を持ちます（`x` と同じ型、または型 `T` の）。

# 例

```jldoctest
julia> oneunit(3.7)
1.0

julia> import Dates; oneunit(Dates.Day)
1 day
```
