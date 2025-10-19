```julia
@test_skip ex
@test_skip f(args...) key=val ...
```

テストを実行しないが、テストサマリー報告には `Broken` として含めるべきであることを示します。これは、断続的に失敗するテストや、まだ実装されていない機能のテストに役立ちます。これは [`@test ex skip=true`](@ref @test) と同等です。

`@test_skip f(args...) key=val...` の形式は `@test` マクロと同様に機能します。

# 例

```jldoctest
julia> @test_skip 1 == 2
Test Broken
  Skipped: 1 == 2

julia> @test_skip 1 == 2 atol=0.1
Test Broken
  Skipped: ==(1, 2, atol = 0.1)
```
