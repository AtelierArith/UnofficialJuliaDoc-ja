```
sprint(f::Function, args...; context=nothing, sizehint=0)
```

Call the given function with an I/O stream and the supplied extra arguments. Everything written to this I/O stream is returned as a string. `context` can be an [`IOContext`](@ref) whose properties will be used, a `Pair` specifying a property and its value, or a tuple of `Pair` specifying multiple properties and their values. `sizehint` suggests the capacity of the buffer (in bytes).

The optional keyword argument `context` can be set to a `:key=>value` pair, a tuple of `:key=>value` pairs, or an `IO` or [`IOContext`](@ref) object whose attributes are used for the I/O stream passed to `f`.  The optional `sizehint` is a suggested size (in bytes) to allocate for the buffer used to write the string.

!!! compat "Julia 1.7"
    Passing a tuple to keyword `context` requires Julia 1.7 or later.


# Examples

```jldoctest
julia> sprint(show, 66.66666; context=:compact => true)
"66.6667"

julia> sprint(showerror, BoundsError([1], 100))
"BoundsError: attempt to access 1-element Vector{Int64} at index [100]"
```
