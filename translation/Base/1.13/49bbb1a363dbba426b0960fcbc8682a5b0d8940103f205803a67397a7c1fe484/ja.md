```julia
mod(x::Integer, r::AbstractUnitRange)
```

`y` が `r` の範囲内で、`x` ≡ `y` (mod `n`) を満たすように求めます。ここで、`n = length(r)`、すなわち `y = mod(x - first(r), n) + first(r)` です。

関連項目: [`mod1`](@ref)。

# Examples

```jldoctest
julia> mod(0, Base.OneTo(3))  # mod1(0, 3)
3

julia> mod(3, 0:2)  # mod(3, 3)
0
```

!!! compat "Julia 1.3"
    このメソッドを使用するには、Julia 1.3 以降が必要です。

