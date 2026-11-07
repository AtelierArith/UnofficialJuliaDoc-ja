```julia
@test_deprecated [pattern] expression
```

`--depwarn=yes`の場合、`expression`が非推奨警告を出力することをテストし、`expression`の値を返します。ログメッセージ文字列は、デフォルトで`r"deprecated"i`となる`pattern`と照合されます。

`--depwarn=no`の場合は、`expression`を実行した結果をそのまま返します。`--depwarn=error`の場合は、ErrorExceptionがスローされることを確認します。

# Examples

```julia
# Deprecated in julia 0.7
@test_deprecated num2hex(1)

# The returned value can be tested by chaining with @test:
@test (@test_deprecated num2hex(1)) == "0000000000000001"
```
