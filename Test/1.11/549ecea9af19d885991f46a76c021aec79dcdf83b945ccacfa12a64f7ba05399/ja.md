```
Test.Error <: Test.Result
```

テスト条件は例外のために評価できなかったか、[`Bool`](@ref) 以外の何かに評価されました。`@test_broken` の場合、予期しない `Pass` `Result` が発生したことを示すために使用されます。
