```julia
repr(x; context=nothing)
```

Create a string representation of any value using the 2-argument `show(io, x)` function, which aims to produce a string that is parseable Julia code, where possible. i.e. `eval(Meta.parse(repr(x))) == x` should hold true. You should not add methods to `repr`; define a [`show`](@ref) method instead.

The optional keyword argument `context` can be set to a `:key=>value` pair, a tuple of `:key=>value` pairs, or an `IO` or [`IOContext`](@ref) object whose attributes are used for the I/O stream passed to `show`.

Note that `repr(x)` is usually similar to how the value of `x` would be entered in Julia.  See also [`repr(MIME("text/plain"), x)`](@ref) to instead return a "pretty-printed" version of `x` designed more for human consumption, equivalent to the REPL display of `x`, using the 3-argument `show(io, mime, x)`.

!!! compat "Julia 1.7"
    Passing a tuple to keyword `context` requires Julia 1.7 or later.


# Examples

```jldoctest
julia> repr(1)
"1"

julia> repr(zeros(3))
"[0.0, 0.0, 0.0]"

julia> repr(big(1/3))
"0.333333333333333314829616256247390992939472198486328125"

julia> repr(big(1/3), context=:compact => true)
"0.333333"

```
