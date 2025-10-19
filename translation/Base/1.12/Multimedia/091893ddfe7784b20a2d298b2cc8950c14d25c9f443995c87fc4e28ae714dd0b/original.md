```julia
display(x)
display(d::AbstractDisplay, x)
display(mime, x)
display(d::AbstractDisplay, mime, x)
```

Display `x` using the topmost applicable display in the display stack, typically using the richest supported multimedia output for `x`, with plain-text [`stdout`](@ref) output as a fallback. The `display(d, x)` variant attempts to display `x` on the given display `d` only, throwing a [`MethodError`](@ref) if `d` cannot display objects of this type.

In general, you cannot assume that `display` output goes to `stdout` (unlike [`print(x)`](@ref) or [`show(x)`](@ref)).  For example, `display(x)` may open up a separate window with an image. `display(x)` means "show `x` in the best way you can for the current output device(s)." If you want REPL-like text output that is guaranteed to go to `stdout`, use [`show(stdout, "text/plain", x)`](@ref) instead.

There are also two variants with a `mime` argument (a MIME type string, such as `"image/png"`), which attempt to display `x` using the requested MIME type *only*, throwing a `MethodError` if this type is not supported by either the display(s) or by `x`. With these variants, one can also supply the "raw" data in the requested MIME type by passing `x::AbstractString` (for MIME types with text-based storage, such as text/html or application/postscript) or `x::Vector{UInt8}` (for binary MIME types).

To customize how instances of a type are displayed, overload [`show`](@ref) rather than `display`, as explained in the manual section on [custom pretty-printing](@ref man-custom-pretty-printing).
