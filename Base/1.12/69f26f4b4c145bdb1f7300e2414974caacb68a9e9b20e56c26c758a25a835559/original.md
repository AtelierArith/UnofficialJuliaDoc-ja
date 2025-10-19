```julia
IOBuffer([data::AbstractVector{UInt8}]; keywords...) -> IOBuffer
```

Create an in-memory I/O stream, which may optionally operate on a pre-existing array.

It may take optional keyword arguments:

  * `read`, `write`, `append`: restricts operations to the buffer; see `open` for details.
  * `truncate`: truncates the buffer size to zero length.
  * `maxsize`: specifies a size beyond which the buffer may not be grown.
  * `sizehint`: suggests a capacity of the buffer (`data` must implement `sizehint!(data, size)`).

When `data` is not given, the buffer will be both readable and writable by default.

!!! warning "Passing `data` as scratch space to `IOBuffer` with `write=true` may give unexpected behavior"
    Once `write` is called on an `IOBuffer`, it is best to consider any previous references to `data` invalidated; in effect `IOBuffer` "owns" this data until a call to `take!`. Any indirect mutations to `data` could lead to undefined behavior by breaking the abstractions expected by `IOBuffer`. If `write=true` the IOBuffer may store data at any offset leaving behind arbitrary values at other offsets. If `maxsize > length(data)`, the IOBuffer might re-allocate the data entirely, which may or may not be visible in any outstanding bindings to `array`.


# Examples

```jldoctest
julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.", " It has many members.")
56

julia> String(take!(io))
"JuliaLang is a GitHub organization. It has many members."

julia> io = IOBuffer(b"JuliaLang is a GitHub organization.")
IOBuffer(data=UInt8[...], readable=true, writable=false, seekable=true, append=false, size=35, maxsize=Inf, ptr=1, mark=-1)

julia> read(io, String)
"JuliaLang is a GitHub organization."

julia> write(io, "This isn't writable.")
ERROR: ArgumentError: ensureroom failed, IOBuffer is not writeable

julia> io = IOBuffer(UInt8[], read=true, write=true, maxsize=34)
IOBuffer(data=UInt8[...], readable=true, writable=true, seekable=true, append=false, size=0, maxsize=34, ptr=1, mark=-1)

julia> write(io, "JuliaLang is a GitHub organization.")
34

julia> String(take!(io))
"JuliaLang is a GitHub organization"

julia> length(read(IOBuffer(b"data", read=true, truncate=false)))
4

julia> length(read(IOBuffer(b"data", read=true, truncate=true)))
0
```
