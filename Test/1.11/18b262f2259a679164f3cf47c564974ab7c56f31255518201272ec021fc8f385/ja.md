```julia
@test_broken ex
@test_broken f(args...) key=val ...
```

本来は成功するはずなのに、現在は常に失敗するテストを示します。式 `ex` が `false` と評価されるか、例外を発生させるかをテストします。そうなる場合は `Broken` `Result` を返し、式が `true` と評価される場合は `Error` `Result` を返します。これは [`@test ex broken=true`](@ref @test) と同等です。

`@test_broken f(args...) key=val...` 形式は、`@test` マクロと同様に動作します。

# Examples

```jldoctest
julia> @test_broken 1 == 2
Test Broken
  Expression: 1 == 2

julia> @test_broken 1 == 2 atol=0.1
Test Broken
  Expression: ==(1, 2, atol = 0.1)
```
