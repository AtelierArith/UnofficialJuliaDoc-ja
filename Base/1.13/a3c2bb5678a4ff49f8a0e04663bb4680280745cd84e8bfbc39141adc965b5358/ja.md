```julia
rem(x::Integer, T::Type{<:Integer})::T
mod(x::Integer, T::Type{<:Integer})::T
%(x::Integer, T::Type{<:Integer})::T
```

`y` が `[typemin(T),typemax(T)]` の整数であるとき、`x` ≡ `y` (mod n) を満たす `y::T` を求めます。ここで、n は `T` で表現可能な整数の個数です。`T` が任意の整数を表現できる場合（例：`T == BigInt`）、この演算は `T` への変換に相当します。

# Examples

```jldoctest
julia> x = 129 % Int8
-127

julia> typeof(x)
Int8

julia> x = 129 % BigInt
129

julia> typeof(x)
BigInt
```
