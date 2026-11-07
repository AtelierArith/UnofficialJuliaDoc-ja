```julia
signbit(x)
```

`x` の符号が負の場合は `true` を返し、それ以外の場合は `false` を返します。

[`sign`](@ref) および [`copysign`](@ref) も参照してください。

# Examples

```jldoctest
julia> signbit(-4)
true

julia> signbit(5)
false

julia> signbit(5.5)
false

julia> signbit(-4.1)
true
```
