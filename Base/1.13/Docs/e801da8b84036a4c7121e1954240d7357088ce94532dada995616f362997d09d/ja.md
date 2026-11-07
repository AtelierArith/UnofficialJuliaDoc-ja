```julia
Docs.hasdoc(mod::Module, sym::Symbol)::Bool
```

`true` を返します。ただし、`mod` 内の `sym` に docstring がある場合は `false` を返します。
