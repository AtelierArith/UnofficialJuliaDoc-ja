```julia
repr(mime, x; context=nothing)
```

Return an `AbstractString` or `Vector{UInt8}` containing the representation of `x` in the requested `mime` type, as written by [`show(io, mime, x)`](@ref) (throwing a [`MethodError`](@ref) if no appropriate `show` is available). An `AbstractString` is returned for MIME types with textual representations (such as `"text/html"` or `"application/postscript"`), whereas binary data is returned as `Vector{UInt8}`. (The function `istextmime(mime)` returns whether or not Julia treats a given `mime` type as text.)

The optional keyword argument `context` can be set to `:key=>value` pair or an `IO` or [`IOContext`](@ref) object whose attributes are used for the I/O stream passed to `show`.

As a special case, if `x` is an `AbstractString` (for textual MIME types) or a `Vector{UInt8}` (for binary MIME types), the `repr` function assumes that `x` is already in the requested `mime` format and simply returns `x`. This special case does not apply to the `"text/plain"` MIME type. This is useful so that raw data can be passed to `display(m::MIME, x)`.

In particular, `repr("text/plain", x)` is typically a "pretty-printed" version of `x` designed for human consumption.  See also [`repr(x)`](@ref) to instead return a string corresponding to [`show(x)`](@ref) that may be closer to how the value of `x` would be entered in Julia.

# Examples

```jldoctest
julia> A = [1 2; 3 4];

julia> repr("text/plain", A)
"2×2 Matrix{Int64}:\n 1  2\n 3  4"
```
