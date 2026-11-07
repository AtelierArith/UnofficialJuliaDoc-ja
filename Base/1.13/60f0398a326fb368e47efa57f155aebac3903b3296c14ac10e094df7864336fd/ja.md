```julia
ispow2(n::Number)::Bool
```

`n` が 2 の整数乗かどうかを判定します。

関連項目: [`count_ones`](@ref)、[`prevpow`](@ref)、[`nextpow`](@ref)。

# Examples

```jldoctest
julia> ispow2(4)
true

julia> ispow2(5)
false

julia> ispow2(4.5)
false

julia> ispow2(0.25)
true

julia> ispow2(1//8)
true
```

!!! compat "Julia 1.6"
    `Integer` 以外の引数への対応は Julia 1.6 で追加されました。

