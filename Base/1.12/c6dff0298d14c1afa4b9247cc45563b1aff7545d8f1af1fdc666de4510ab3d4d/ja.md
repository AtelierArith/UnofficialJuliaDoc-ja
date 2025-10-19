```julia
oneunit(x::T)
oneunit(T::Type)
```

引数の型が `T` である場合、または `oneunit` が型からのみ推測できる場合には、`T(one(x))` を返します。これは、次元を持つ量に対する [`one`](@ref) とは異なります：`one` は次元を持たない（乗法的単位）ですが、`oneunit` は次元を持ちます（`x` と同じ型、または型 `T` の）。

# 例

```jldoctest
julia> oneunit(3.7)
1.0

julia> import Dates; oneunit(Dates.Day)
1 day
```
