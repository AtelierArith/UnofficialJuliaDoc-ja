```julia
Test.Error <: Test.Result
```

例外が発生したためテスト条件を評価できなかったか、評価結果が[`Bool`](@ref)以外でした。`@test_broken`の場合は、予期しない`Pass` `Result`が発生したことを示します。
