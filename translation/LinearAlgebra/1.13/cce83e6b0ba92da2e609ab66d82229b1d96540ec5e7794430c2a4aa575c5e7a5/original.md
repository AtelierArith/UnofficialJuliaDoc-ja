```julia
rotate!(x, y, c, s)
```

Overwrite `x` with `s*y + c*x` and `y` with `c*y - conj(s)*x`. Returns `x` and `y`.

!!! compat "Julia 1.5"
    `rotate!` requires at least Julia 1.5.

