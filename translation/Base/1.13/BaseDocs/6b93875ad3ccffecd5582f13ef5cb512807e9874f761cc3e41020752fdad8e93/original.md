```julia
UInt
```

Sys.WORD_SIZE-bit unsigned integer type, `UInt <: Unsigned <: Integer`.

Like [`Int`](@ref Int), the alias `UInt` may point to either `UInt32` or `UInt64`, according to the value of `Sys.WORD_SIZE` on a given computer.

Printed and parsed in hexadecimal: `UInt(15) === 0x000000000000000f`.
