```julia
tokenize(x)
```

Returns an `Iterable` containing the tokenized input. Can be reverted by e.g. `join(untokenize.(tokenize(x)))`.
