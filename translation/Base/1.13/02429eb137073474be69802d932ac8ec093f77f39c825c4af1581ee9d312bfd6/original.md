```julia
TwicePrecision{T}(hi::T, lo::T)
TwicePrecision{T}((num, denom))
```

A number with twice the precision of `T`, e.g., quad-precision if `T = Float64`.

!!! warning
    `TwicePrecision` is an internal type used to increase the precision of floating-point ranges, and not intended for external use. If you encounter them in real code, the most likely explanation is that you are directly accessing the fields of a range. Use the function interface instead, `step(r)` rather than `r.step`


# Extended help

`hi` represents the high bits (most significant bits) and `lo` the low bits (least significant bits). Rational values `num//denom` can be approximated conveniently using the syntax `TwicePrecision{T}((num, denom))`.

When used with `T<:Union{Float16,Float32,Float64}` to construct an "exact" `StepRangeLen`, `ref` should be the range element with smallest magnitude and `offset` set to the corresponding index.  For efficiency, multiplication of `step` by the index is not performed at twice precision: `step.hi` should have enough trailing zeros in its `bits` representation that `(0:len-1)*step.hi` is exact (has no roundoff error).  If `step` has an exact rational representation `num//denom`, then you can construct `step` using

```julia
step = TwicePrecision{T}((num, denom), nb)
```

where `nb` is the number of trailing zero bits of `step.hi`.  For ranges, you can set `nb = ceil(Int, log2(len-1))`.
