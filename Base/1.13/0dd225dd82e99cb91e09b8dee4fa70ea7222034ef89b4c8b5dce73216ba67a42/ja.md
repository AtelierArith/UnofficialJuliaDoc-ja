```julia
Base.mapreduce_first(f, op, x)
```

[`mapreduce`](@ref)、[`mapfoldl`](@ref)、または [`mapfoldr`](@ref) を、`f` によるマップと `op` によるリダクションを指定して、単一の要素 `x` を含むイテレータに対して呼び出したときに返される値です。この値は再帰の初期化にも使用でき、その場合 `mapreduce(f, op, [x, y])` は `op(mapreduce_first(f, op, x), f(y))` を呼び出せます。

デフォルトは `reduce_first(op, f(x))` です。
