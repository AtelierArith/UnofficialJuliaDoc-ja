```julia
Char(c::Union{Number,AbstractChar})
```

`Char` is a 32-bit [`AbstractChar`](@ref) type that is the default representation of characters in Julia. `Char` is the type used for character literals like `'x'` and it is also the element type of [`String`](@ref).

In order to losslessly represent arbitrary byte streams stored in a `String`, a `Char` value may store information that cannot be converted to a Unicode codepoint — converting such a `Char` to `UInt32` will throw an error. The [`isvalid(c::Char)`](@ref) function can be used to query whether `c` represents a valid Unicode character.
