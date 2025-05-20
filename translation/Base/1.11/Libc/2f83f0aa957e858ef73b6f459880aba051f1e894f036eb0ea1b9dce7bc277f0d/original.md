```
FILE(::Ptr)
FILE(::IO)
```

A libc `FILE*`, representing an opened file.

It can be passed as a `Ptr{FILE}` argument to [`ccall`](@ref) and also supports [`seek`](@ref), [`position`](@ref) and [`close`](@ref).

A `FILE` can be constructed from an ordinary `IO` object, provided it is an open file. It must be closed afterward.

# Examples

```jldoctest
julia> using Base.Libc

julia> mktemp() do _, io
           # write to the temporary file using `puts(char*, FILE*)` from libc
           file = FILE(io)
           ccall(:fputs, Cint, (Cstring, Ptr{FILE}), "hello world", file)
           close(file)
           # read the file again
           seek(io, 0)
           read(io, String)
       end
"hello world"
```
