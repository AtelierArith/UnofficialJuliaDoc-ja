```julia
@test ex
@test f(args...) key=val ...
@test ex broken=true
@test ex skip=true
```

式 `ex` が `true` に評価されることをテストします。`@testset` 内で実行された場合、評価が成功すれば `Pass` `Result` を返し、`false` であれば `Fail` `Result` を返し、評価できなければ `Error` `Result` を返します。`@testset` の外で実行された場合は、`Fail` または `Error` を返す代わりに例外をスローします。

# 例

```jldoctest
julia> @test true
Test Passed

julia> @test [1, 2] + [2, 1] == [3, 3]
Test Passed
```

`@test f(args...) key=val...` の形式は `@test f(args..., key=val...)` と同等であり、近似比較のような中置構文を使用する呼び出し式の場合に便利です：

```jldoctest
julia> @test π ≈ 3.14 atol=0.01
Test Passed
```

これは、より見栄えの悪いテスト `@test ≈(π, 3.14, atol=0.01)` と同等です。最初の式が呼び出し式であり、残りが代入（`k=v`）でない限り、複数の式を供給することはエラーです。

`key=val` 引数には、`broken` と `skip` を除いて任意のキーを使用できます。これらは `@test` の文脈で特別な意味を持ちます：

  * `broken=cond` は、テストが通るべきだが現在は `cond==true` のときに一貫して失敗することを示します。式 `ex` が `false` に評価されるか、例外を引き起こすテストです。これが成立すれば `Broken` `Result` を返し、式が `true` に評価されれば `Error` `Result` を返します。通常の `@test ex` は `cond==false` のときに評価されます。
  * `skip=cond` は、実行されるべきではないが、`cond==true` のときにテストサマリー報告に `Broken` として含めるべきテストをマークします。これは、断続的に失敗するテストや、まだ実装されていない機能のテストに便利です。通常の `@test ex` は `cond==false` のときに評価されます。

# 例

```jldoctest
julia> @test 2 + 2 ≈ 6 atol=1 broken=true
Test Broken
  Expression: ≈(2 + 2, 6, atol = 1)

julia> @test 2 + 2 ≈ 5 atol=1 broken=false
Test Passed

julia> @test 2 + 2 == 5 skip=true
Test Broken
  Skipped: 2 + 2 == 5

julia> @test 2 + 2 == 4 skip=false
Test Passed
```

!!! compat "Julia 1.7"
    `broken` および `skip` キーワード引数は、少なくとも Julia 1.7 が必要です。

