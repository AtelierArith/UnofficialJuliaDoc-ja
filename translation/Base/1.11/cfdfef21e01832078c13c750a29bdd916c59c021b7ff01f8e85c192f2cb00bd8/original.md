```
ceil([T,] x)
ceil(x; digits::Integer= [, base = 10])
ceil(x; sigdigits::Integer= [, base = 10])
```

`ceil(x)` returns the nearest integral value of the same type as `x` that is greater than or equal to `x`.

`ceil(T, x)` converts the result to type `T`, throwing an `InexactError` if the ceiled value is not representable as a `T`.

Keywords `digits`, `sigdigits` and `base` work as for [`round`](@ref).

To support `ceil` for a new type, define `Base.round(x::NewType, ::RoundingMode{:Up})`.
