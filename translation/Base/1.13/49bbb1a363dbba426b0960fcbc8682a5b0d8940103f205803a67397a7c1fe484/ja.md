```julia
mod(x::Integer, r::AbstractUnitRange)
```

範囲 `r` 内で、`x` ≡ `y` (mod `n`) を満たす `y` を求めます。ここで `n = length(r)`、つまり `y = mod(x - first(r), n) + first(r)` です。

[`mod1`](@ref) も参照してください。

# Examples

```jldoctest
julia> mod(0, Base.OneTo(3))  # mod1(0, 3)
3

julia> mod(3, 0:2)  # mod(3, 3)
0
```

!!! compat "Julia 1.3"
    このメソッドを使用するには、Julia 1.3 以降が必要です。

