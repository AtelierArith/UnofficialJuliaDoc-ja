```julia
ndigits0z(n::Integer, b::Integer=10)
```

Return 0 if `n == 0`, otherwise compute the number of digits in integer `n` written in base `b` (i.e. equal to `ndigits(n, base=b)` in this case). The base `b` must not be in `[-1, 0, 1]`.

# Examples

```jldoctest
julia> Base.ndigits0z(0, 16)
0

julia> Base.ndigits(0, base=16)
1

julia> Base.ndigits0z(0)
0

julia> Base.ndigits0z(10, 2)
4

julia> Base.ndigits0z(10)
2
```

See also [`ndigits`](@ref).
