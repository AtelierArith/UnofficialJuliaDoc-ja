```julia
stringmime(mime, x; context=nothing)
```

Return an `AbstractString` containing the representation of `x` in the requested `mime` type. This is similar to [`repr(mime, x)`](@ref) except that binary data is base64-encoded as an ASCII string.

The optional keyword argument `context` can be set to `:key=>value` pair or an `IO` or [`IOContext`](@ref) object whose attributes are used for the I/O stream passed to [`show`](@ref).
