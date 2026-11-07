```julia
oneunit(x::T)
oneunit(T::Type)
```

`T(one(x))`を返します。ここで、`T`は引数の型です。ただし、型だけから`oneunit`を推定できる場合は、引数そのものを返します。これは、次元を持つ量の場合の[`one`](@ref)とは異なります。`one`は無次元（乗法単位元）ですが、`oneunit`は次元を持ちます（`x`と同じ型、または`T`型です）。

# Examples

```jldoctest
julia> oneunit(3.7)
1.0

julia> import Dates; oneunit(Dates.Day)
1 day
```
