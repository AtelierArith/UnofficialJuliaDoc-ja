```julia
print_statement_costs(io::IO, f, types)
```

Print type-inferred and optimized code for `f` given argument types `types`, prepending each line with its cost as estimated by the compiler's inlining engine.
