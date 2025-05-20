```
setprecision(f::Function, [T=BigFloat,] precision::Integer; base=2)
```

Change the `T` arithmetic precision (in the given `base`) for the duration of `f`. It is logically equivalent to:

```
old = precision(BigFloat)
setprecision(BigFloat, precision)
f()
setprecision(BigFloat, old)
```

Often used as `setprecision(T, precision) do ... end`

Note: `nextfloat()`, `prevfloat()` do not use the precision mentioned by `setprecision`.

!!! compat "Julia 1.8"
    The `base` keyword requires at least Julia 1.8.

