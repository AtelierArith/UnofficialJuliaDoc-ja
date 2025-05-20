```
rem(x::Integer, T::Type{<:Integer}) -> T
mod(x::Integer, T::Type{<:Integer}) -> T
%(x::Integer, T::Type{<:Integer}) -> T
```

`y::T` を見つけるには、`x` ≡ `y` (mod n) を満たす必要があります。ここで、n は `T` で表現可能な整数の数であり、`y` は `[typemin(T),typemax(T)]` の範囲内の整数です。もし `T` が任意の整数を表現できる場合（例: `T == BigInt`）、この操作は `T` への変換に対応します。

# 例

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
