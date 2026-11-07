```julia
Base.mapreduce_empty(f, op, T)
```

要素型が `T` の空配列に対して、map に `f`、reduction に `op` を指定して [`mapreduce`](@ref)、[`mapfoldl`](@ref)、または [`mapfoldr`](@ref) を呼び出したときに返される値です。詳しくは [`Base.reduce_empty`](@ref) を参照してください。
