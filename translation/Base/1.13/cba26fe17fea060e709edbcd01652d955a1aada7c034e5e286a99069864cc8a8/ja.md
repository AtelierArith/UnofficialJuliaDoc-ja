```julia
_prechecked_iterate(iter[, state])
```

`iterate` 内のデッドブランチを除去するために使われる内部関数です。デフォルトでは `iterate` にフォールバックしますが、`Base` のインデックス型に最適化されています。
