```
x || y
```

Short-circuiting boolean OR.

See also: [`|`](@ref), [`xor`](@ref), [`&&`](@ref).

# Examples

```jldoctest
julia> pi < 3 || ℯ < 3
true

julia> false || true || println("neither is true!")
true
```
