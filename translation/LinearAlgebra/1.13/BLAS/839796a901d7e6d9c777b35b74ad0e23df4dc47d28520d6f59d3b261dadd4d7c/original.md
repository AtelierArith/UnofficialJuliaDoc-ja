```julia
dotc(n, X, incx, U, incy)
```

Dot function for two complex vectors, consisting of `n` elements of array `X` with stride `incx` and `n` elements of array `U` with stride `incy`, conjugating the first vector.

# Examples

```jldoctest
julia> BLAS.dotc(10, fill(1.0im, 10), 1, fill(1.0+im, 20), 2)
10.0 - 10.0im
```
