```julia
_prechecked_iterate(iter[, state])
```

`iterate` 内の到達不能な分岐を除去するために使われる内部関数です。デフォルトでは `iterate` にフォールバックしますが、`Base` のインデックス型に最適化されています。
