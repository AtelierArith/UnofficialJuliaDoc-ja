```julia
Fix{N}(f, x)
```

A type representing a partially-applied version of a function `f`, with the argument `x` fixed at position `N::Int`. In other words, `Fix{3}(f, x)` behaves similarly to `(y1, y2, y3...; kws...) -> f(y1, y2, x, y3...; kws...)`.

!!! compat "Julia 1.12"
    This general functionality requires at least Julia 1.12, while `Fix1` and `Fix2` are available earlier.


!!! note
    When nesting multiple `Fix`, note that the `N` in `Fix{N}` is *relative* to the current available arguments, rather than an absolute ordering on the target function. For example, `Fix{1}(Fix{2}(f, 4), 4)` fixes the first and second arg, while `Fix{2}(Fix{1}(f, 4), 4)` fixes the first and third arg.

