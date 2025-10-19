```julia
x || y
```

Short-circuiting boolean OR.

This is equivalent to `x ? true : y`: it returns `true` if `x` is `true` and the result of evaluating `y` if `x` is `false`. Note that if `y` is an expression, it is only evaluated when `x` is `false`, which is called "short-circuiting" behavior.

Also, `y` does not need to have a boolean value.  This means that `(condition) || (statement)` can be used as shorthand for `if !(condition); statement; end` for an arbitrary `statement`.

See also: [`|`](@ref), [`xor`](@ref), [`&&`](@ref).

# Examples

```jldoctest
julia> pi < 3 || ℯ < 3
true

julia> false || true || println("neither is true!")
true

julia> pi < 3 || "not a boolean"
"not a boolean"
```
