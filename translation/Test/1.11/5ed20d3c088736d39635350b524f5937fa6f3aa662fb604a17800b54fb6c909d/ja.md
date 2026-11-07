```julia
test_expr!(ex, kws...)
```

末尾にキーワード引数がある関数呼び出しのテスト式を前処理し、たとえば `@test a ≈ b atol=ε` が `@test ≈(a, b, atol=ε)` を意味するようにします。
