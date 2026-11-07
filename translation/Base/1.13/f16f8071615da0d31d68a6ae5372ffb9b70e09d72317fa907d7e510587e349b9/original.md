```julia
@irrational sym [val] def
```

Define a new `Irrational` value, `sym`, with arbitrary-precision definition in terms of `BigFloat`s given by the expression `def`.

Optionally provide a pre-computed `Float64` value `val` which must equal `Float64(def)`. `val` will be computed automatically if omitted.

An `AssertionError` is thrown when either `big(def) isa BigFloat` or `Float64(val) == Float64(def)` returns `false`.

!!! warning
    This macro should not be used outside of `Base` Julia.

    The macro creates a new type `Irrational{:sym}` regardless of where it's invoked. This can lead to conflicting definitions if two packages define an irrational number with the same name but different values.


# Examples

```jldoctest
julia> Base.@irrational twoπ 2*big(π)

julia> twoπ
twoπ = 6.2831853071795...

julia> Base.@irrational sqrt2 1.4142135623730950488 √big(2)

julia> sqrt2
sqrt2 = 1.4142135623730...

julia> Base.@irrational sqrt2 1.4142135623730950488 big(2)
ERROR: AssertionError: big($(Expr(:escape, :sqrt2))) isa BigFloat

julia> Base.@irrational sqrt2 1.41421356237309 √big(2)
ERROR: AssertionError: Float64($(Expr(:escape, :sqrt2))) == Float64(big($(Expr(:escape, :sqrt2))))
```
