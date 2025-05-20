```
floor([T,] x)
floor(x; digits::Integer= [, base = 10])
floor(x; sigdigits::Integer= [, base = 10])
```

`floor(x)` returns the nearest integral value of the same type as `x` that is less than or equal to `x`.

`floor(T, x)` converts the result to type `T`, throwing an `InexactError` if the floored value is not representable a `T`.

Keywords `digits`, `sigdigits` and `base` work as for [`round`](@ref).

To support `floor` for a new type, define `Base.round(x::NewType, ::RoundingMode{:Down})`.
