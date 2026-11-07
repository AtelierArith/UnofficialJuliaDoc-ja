```julia
unsafe_takestring(m::Memory{UInt8})::String
```

Create a `String` from `m`, changing the interpretation of the contents of `m`. This is done without copying, if possible. Thus, any access to `m` after calling this function, either to read or to write, is undefined behavior.
