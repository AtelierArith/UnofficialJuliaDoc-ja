```julia
DomainError(val)
DomainError(val, msg)
```

関数またはコンストラクターに渡された引数 `val` は、有効な定義域の範囲外です。

# Examples

```jldoctest
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]
```
