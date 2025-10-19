```julia
@fastmath expr
```

Execute a transformed version of the expression, which calls functions that may violate strict IEEE semantics. This allows the fastest possible operation, but results are undefined – be careful when doing this, as it may change numerical results.

This sets the [LLVM Fast-Math flags](https://llvm.org/docs/LangRef.html#fast-math-flags), and corresponds to the `-ffast-math` option in clang. See [the notes on performance annotations](@ref man-performance-annotations) for more details.

# Examples

```jldoctest
julia> @fastmath 1+2
3

julia> @fastmath(sin(3))
0.1411200080598672
```
