```julia
oneunit(x::T)
oneunit(T::Type)
```

`T(one(x))`を返します。`T`は引数の型、または型だけから`oneunit`を推定できる場合は引数そのものです。これは次元を持つ量の場合、[`one`](@ref)とは異なります。`one`は無次元（乗法単位元）ですが、`oneunit`は次元を持ちます（`x`と同じ型、または`T`型です）。

# Examples

```jldoctest
julia> oneunit(3.7)
1.0

julia> import Dates; oneunit(Dates.Day)
1 day
```
