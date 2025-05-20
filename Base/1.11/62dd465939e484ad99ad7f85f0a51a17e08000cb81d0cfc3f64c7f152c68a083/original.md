```
unsafe_copyto!(dest::Array, do, src::Array, so, N)
```

Copy `N` elements from a source array to a destination, starting at the linear index `so` in the source and `do` in the destination (1-indexed).

The `unsafe` prefix on this function indicates that no validation is performed to ensure that N is inbounds on either array. Incorrect usage may corrupt or segfault your program, in the same manner as C.
