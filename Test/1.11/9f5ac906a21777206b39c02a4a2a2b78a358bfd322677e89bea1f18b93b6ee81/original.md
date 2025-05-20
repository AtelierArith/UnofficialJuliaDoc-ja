```
test_expr!(ex, kws...)
```

Preprocess test expressions of function calls with trailing keyword arguments so that e.g. `@test a ≈ b atol=ε` means `@test ≈(a, b, atol=ε)`.
