```julia
SMALL_ALGORITHM
```

Default sorting algorithm for small arrays.

This is an alias for a simple low-overhead algorithm that does not scale well to large arrays, unlike high-overhead recursive algorithms used for larger arrays. `SMALL_ALGORITHM` is a good choice for the base case of a recursive algorithm.
