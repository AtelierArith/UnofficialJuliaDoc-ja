```julia
ZeroPivotException <: Exception
```

Exception thrown when a matrix factorization/solve encounters a zero in a pivot (diagonal) position and cannot proceed.  This may *not* mean that the matrix is singular: it may be fruitful to switch to a different factorization such as pivoted LU that can re-order variables to eliminate spurious zero pivots. The `info` field indicates the location of (one of) the zero pivot(s).
