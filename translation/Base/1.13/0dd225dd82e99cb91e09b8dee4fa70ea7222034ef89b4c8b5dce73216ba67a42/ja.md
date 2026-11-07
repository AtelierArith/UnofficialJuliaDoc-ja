```julia
Base.mapreduce_first(f, op, x)
```

単一の要素 `x` を含むイテレータに対して、写像 `f` とリダクション `op` を指定して [`mapreduce`](@ref)、[`mapfoldl`](@ref) または [`mapfoldr`](@ref) を呼び出したときに返される値です。この値は再帰の初期化にも使用できるため、`mapreduce(f, op, [x, y])` は `op(mapreduce_first(f, op, x), f(y))` を呼び出す場合があります。

デフォルトは `reduce_first(op, f(x))` です。
