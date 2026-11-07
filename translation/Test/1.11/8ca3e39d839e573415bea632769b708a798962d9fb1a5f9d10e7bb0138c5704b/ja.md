```julia
@test ex
@test f(args...) key=val ...
@test ex broken=true
@test ex skip=true
```

式 `ex` が `true` と評価されることをテストします。`@testset` の内部で実行された場合、式がそのとおりなら `Pass` `Result` を、`false` なら `Fail` `Result` を、評価できなかった場合は `Error` `Result` を返します。`@testset` の外で実行された場合は、`Fail` や `Error` を返す代わりに例外をスローします。

# Examples

```jldoctest
julia> @test true
Test Passed

julia> @test [1, 2] + [2, 1] == [3, 3]
Test Passed
```

`@test f(args...) key=val...` 形式は `@test f(args..., key=val...)` と書くのと同等です。これは、近似比較のように中置記法を使った呼び出し式をテストする場合に便利です。

```jldoctest
julia> @test π ≈ 3.14 atol=0.01
Test Passed
```

これは、より冗長なテスト `@test ≈(π, 3.14, atol=0.01)` と同等です。最初の式が呼び出し式で、残りが代入式（`k=v`）である場合を除き、複数の式を指定するとエラーになります。

`broken` と `skip` は `@test` のコンテキストで特別な意味を持つため、`key=val` 引数にはこれら以外の任意のキーを使用できます。

  * `broken=cond` は、成功するはずなのに `cond==true` のときに一貫して失敗するテストを示します。式 `ex` が `false` と評価されるか、例外を発生させることをテストします。そうであれば `Broken` `Result` を返し、式が `true` と評価された場合は `Error` `Result` を返します。通常の `@test ex` は `cond==false` のときに評価されます。
  * `skip=cond` は、実行はしないものの、`cond==true` のときにテスト概要へ `Broken` として含めるテストを示します。断続的に失敗するテストや、まだ実装されていない機能のテストに便利です。通常の `@test ex` は `cond==false` のときに評価されます。

# Examples

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
    `broken` および `skip` キーワード引数を使用するには、Julia 1.7 以降が必要です。

