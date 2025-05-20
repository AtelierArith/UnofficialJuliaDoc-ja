```
@test_deprecated [pattern] expression
```

`--depwarn=yes` の場合、`expression` が非推奨警告を発することをテストし、`expression` の値を返します。ログメッセージ文字列は、デフォルトで `r"deprecated"i` に対して `pattern` と一致します。

`--depwarn=no` の場合、単に `expression` を実行した結果を返します。`--depwarn=error` の場合、ErrorException がスローされることを確認します。

# 例

```
# julia 0.7 で非推奨
@test_deprecated num2hex(1)

# 戻り値は @test でチェーンすることでテストできます:
@test (@test_deprecated num2hex(1)) == "0000000000000001"
```
