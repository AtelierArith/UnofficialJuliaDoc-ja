```julia
fzeropreserving(bc) -> Bool
```

Return true if the broadcasted function call evaluates to zero for structural zeros of the structured arguments.

For trivial broadcasted values such as `bc::Number`, this reduces to `iszero(bc)`.
