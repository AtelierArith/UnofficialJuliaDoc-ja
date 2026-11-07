```julia
Meta.isexpr(ex, head[, n])::Bool
```

Return `true` if `ex` is an `Expr` with the given type `head` and optionally that the argument list is of length `n`. `head` may be a `Symbol` or collection of `Symbol`s. For example, to check that a macro was passed a function call expression, you might use `isexpr(ex, :call)`.

# Examples

```jldoctest
julia> ex = :(f(x))
:(f(x))

julia> Meta.isexpr(ex, :block)
false

julia> Meta.isexpr(ex, :call)
true

julia> Meta.isexpr(ex, [:block, :call]) # multiple possible heads
true

julia> Meta.isexpr(ex, :call, 1)
false

julia> Meta.isexpr(ex, :call, 2)
true
```
