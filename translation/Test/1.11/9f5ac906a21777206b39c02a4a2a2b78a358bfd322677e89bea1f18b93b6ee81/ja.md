```
test_expr!(ex, kws...)
```

関数呼び出しのテスト式を前処理し、例えば `@test a ≈ b atol=ε` が `@test ≈(a, b, atol=ε)` を意味するようにします。
