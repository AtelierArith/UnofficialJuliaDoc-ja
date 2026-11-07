```julia
Any::DataType
```

`Any`は、すべての型の和集合です。任意の`x`に対して、`isa(x, Any) == true`という性質を持ちます。したがって、`Any`は、取り得る値の全体を表します。たとえば、`Integer`は`Any`の部分集合であり、`Int`、`Int8`などの整数型を含みます。
