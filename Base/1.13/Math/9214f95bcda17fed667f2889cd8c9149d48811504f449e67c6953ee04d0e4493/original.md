```julia
rem_pio2_kernel(x::Union{Float32, Float64})
```

Calculate `x` divided by `π/2` accurately for arbitrarily large `x`. Returns a pair `(k, r)`, where `k` is the quadrant of the result (multiple of π/2) and `r` is the remainder, such that ``k * π/2 = x - r``. The remainder is given as a double-double pair. `k` is positive if `x > 0` and is negative if `x ≤ 0`.
