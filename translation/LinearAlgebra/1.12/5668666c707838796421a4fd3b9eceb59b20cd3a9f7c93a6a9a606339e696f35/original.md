```julia
rotate!(x, y, c, s)
```

Overwrite `x` with `c*x + s*y` and `y` with `-conj(s)*x + c*y`. Returns `x` and `y`.

!!! compat "Julia 1.5"
    `rotate!` requires at least Julia 1.5.

