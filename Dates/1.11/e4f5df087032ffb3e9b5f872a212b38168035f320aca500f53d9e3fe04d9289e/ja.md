```julia
Dates.value(x::Period) -> Int64
```

与えられた期間に対して、その期間に関連付けられた値を返します。例えば、`value(Millisecond(10))`は整数として10を返します。
