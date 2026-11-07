```julia
ifelse(condition::Bool, x, y)
```

`x` を返します。ただし、`condition` が `true` の場合に限ります。それ以外の場合は、`y` を返します。これは `?` や `if` とは異なり、通常の関数であるため、すべての引数が先に評価されます。場合によっては、`if` 文の代わりに `ifelse` を使うと、生成されるコードの分岐をなくし、タイトなループでのパフォーマンスを向上させられます。

# Examples

```jldoctest
julia> ifelse(1 > 2, 1, 2)
2
```
