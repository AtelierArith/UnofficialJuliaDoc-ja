```julia
@test_skip ex
@test_skip f(args...) key=val ...
```

テストを実行せず、テストの集計結果には含めるよう指定します。`Broken`として報告されます。断続的に失敗するテストや、まだ実装されていない機能のテストに便利です。これは[`@test ex skip=true`](@ref @test)と同等です。

`@test_skip f(args...) key=val...`形式は、`@test`マクロと同様に動作します。

# Examples

```jldoctest
julia> @test_skip 1 == 2
Test Broken
  Skipped: 1 == 2

julia> @test_skip 1 == 2 atol=0.1
Test Broken
  Skipped: ==(1, 2, atol = 0.1)
```
