```
String <: AbstractString
```

The default string type in Julia, used by e.g. string literals.

`String`s are immutable sequences of `Char`s. A `String` is stored internally as a contiguous byte array, and while they are interpreted as being UTF-8 encoded, they can be composed of any byte sequence. Use [`isvalid`](@ref) to validate that the underlying byte sequence is valid as UTF-8.
