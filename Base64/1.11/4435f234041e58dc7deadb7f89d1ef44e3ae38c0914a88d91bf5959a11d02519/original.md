```
base64encode(writefunc, args...; context=nothing)
base64encode(args...; context=nothing)
```

Given a [`write`](@ref)-like function `writefunc`, which takes an I/O stream as its first argument, `base64encode(writefunc, args...)` calls `writefunc` to write `args...` to a base64-encoded string, and returns the string. `base64encode(args...)` is equivalent to `base64encode(write, args...)`: it converts its arguments into bytes using the standard [`write`](@ref) functions and returns the base64-encoded string.

The optional keyword argument `context` can be set to `:key=>value` pair or an `IO` or [`IOContext`](@ref) object whose attributes are used for the I/O stream passed to `writefunc` or `write`.

See also [`base64decode`](@ref).
