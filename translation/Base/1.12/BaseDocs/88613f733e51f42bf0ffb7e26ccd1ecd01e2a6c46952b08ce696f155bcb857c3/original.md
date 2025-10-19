```julia
Bool <: Integer
```

Boolean type, containing the values `true` and `false`.

`Bool` is a kind of number: `false` is numerically equal to `0` and `true` is numerically equal to `1`. Moreover, `false` acts as a multiplicative "strong zero" against [`NaN`](@ref) and [`Inf`](@ref):

```jldoctest
julia> [true, false] == [1, 0]
true

julia> 42.0 + true
43.0

julia> 0 .* (NaN, Inf, -Inf)
(NaN, NaN, NaN)

julia> false .* (NaN, Inf, -Inf)
(0.0, 0.0, -0.0)
```

Branches via [`if`](@ref) and other conditionals only accept `Bool`. There are no "truthy" values in Julia.

Comparisons typically return `Bool`, and broadcasted comparisons may return [`BitArray`](@ref) instead of an `Array{Bool}`.

```jldoctest
julia> [1 2 3 4 5] .< pi
1×5 BitMatrix:
 1  1  1  0  0

julia> map(>(pi), [1 2 3 4 5])
1×5 Matrix{Bool}:
 0  0  0  1  1
```

See also [`trues`](@ref), [`falses`](@ref), [`ifelse`](@ref).
