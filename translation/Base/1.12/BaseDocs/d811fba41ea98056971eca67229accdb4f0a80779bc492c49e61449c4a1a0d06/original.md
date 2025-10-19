```julia
x && y
```

Short-circuiting boolean AND.

This is equivalent to `x ? y : false`: it returns `false` if `x` is `false` and the result of evaluating `y` if `x` is `true`. Note that if `y` is an expression, it is only evaluated when `x` is `true`, which is called "short-circuiting" behavior.

Also, `y` does not need to have a boolean value.  This means that `(condition) && (statement)` can be used as shorthand for `if condition; statement; end` for an arbitrary `statement`.

See also [`&`](@ref), the ternary operator `? :`, and the manual section on [control flow](@ref man-conditional-evaluation).

# Examples

```jldoctest
julia> x = 3;

julia> x > 1 && x < 10 && x isa Int
true

julia> x < 0 && error("expected positive x")
false

julia> x > 0 && "not a boolean"
"not a boolean"
```
