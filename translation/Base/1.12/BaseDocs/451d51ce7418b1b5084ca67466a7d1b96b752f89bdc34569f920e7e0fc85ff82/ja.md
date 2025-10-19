```julia
Any::DataType
```

`Any` はすべての型の和です。任意の `x` に対して `isa(x, Any) == true` という定義的な性質を持っています。したがって、`Any` は可能な値の全宇宙を表します。例えば、`Integer` は `Int`、`Int8`、および他の整数型を含む `Any` のサブセットです。
