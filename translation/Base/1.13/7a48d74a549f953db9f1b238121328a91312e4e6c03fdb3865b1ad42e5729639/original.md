```julia
hi, lo = splitprec(F::Type{<:AbstractFloat}, i::Integer)
```

Represent an integer `i` as a pair of floating-point numbers `hi` and `lo` (of type `F`) such that:

  * `widen(hi) + widen(lo) ≈ i`. It is exact if 1.5 * (number of precision bits in `F`) is greater than the number of bits in `i`.
  * all bits in `hi` are more significant than any of the bits in `lo`
  * `hi` can be exactly multiplied by the `hi` component of another call to `splitprec`.

In particular, while `convert(Float64, i)` can be lossy since Float64 has only 53 bits of precision, `splitprec(Float64, i)` is exact for any Int64/UInt64.
