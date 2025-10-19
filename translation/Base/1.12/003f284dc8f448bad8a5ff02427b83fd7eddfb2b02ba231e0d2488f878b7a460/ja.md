```julia
mod(x::Integer, r::AbstractUnitRange)
```

範囲 `r` の中で `y` を見つけます。ここで `x` ≡ `y` (mod `n`)、`n = length(r)` です。すなわち、`y = mod(x - first(r), n) + first(r)` です。

他にも [`mod1`](@ref) を参照してください。

# 例

```jldoctest
julia> mod(0, Base.OneTo(3))  # mod1(0, 3)
3

julia> mod(3, 0:2)  # mod(3, 3)
0
```

!!! compat "Julia 1.3"
    このメソッドは少なくとも Julia 1.3 を必要とします。

