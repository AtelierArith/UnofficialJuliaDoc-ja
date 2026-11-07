```julia
unsafe_copyto!(dest::Array, doffs, src::Array, soffs, n)
```

Copy `n` elements from a source array to a destination, starting at the linear index `soffs` in the source and `doffs` in the destination (1-indexed).

The `unsafe` prefix on this function indicates that no validation is performed to ensure that n is inbounds on either array. Incorrect usage may corrupt or segfault your program, in the same manner as C.
