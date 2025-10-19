```julia
rem(x::Integer, T::Type{<:Integer}) -> T
mod(x::Integer, T::Type{<:Integer}) -> T
%(x::Integer, T::Type{<:Integer}) -> T
```

Find `y::T` such that `x` ≡ `y` (mod n), where n is the number of integers representable in `T`, and `y` is an integer in `[typemin(T),typemax(T)]`. If `T` can represent any integer (e.g. `T == BigInt`), then this operation corresponds to a conversion to `T`.

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
