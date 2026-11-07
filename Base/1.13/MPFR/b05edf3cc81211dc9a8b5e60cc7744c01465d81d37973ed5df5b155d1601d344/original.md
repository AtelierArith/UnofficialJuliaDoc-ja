```julia
setprecision(f::Function, [T=BigFloat,] precision::Integer; base=2)
```

Change the `T` arithmetic precision (in the given `base`) for the duration of `f`. It is logically equivalent to:

```julia
old = precision(BigFloat)
setprecision(BigFloat, precision)
f()
setprecision(BigFloat, old)
```

Often used as `setprecision(T, precision) do ... end`

Note: `nextfloat()`, `prevfloat()` do not use the precision mentioned by `setprecision`.

!!! warning
    There is a fallback implementation of this method that calls `precision` and `setprecision`, but it should no longer be relied on. Instead, you should define the 3-argument form directly in a way that uses `ScopedValue`, or recommend that callers use `ScopedValue` and `@with` themselves.


!!! compat "Julia 1.8"
    The `base` keyword requires at least Julia 1.8.

