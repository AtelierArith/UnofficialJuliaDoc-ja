```
@testset [CustomTestSet] [options...] ["説明"] begin test_ex end
@testset [CustomTestSet] [options...] ["説明 $v"] for v in itr test_ex end
@testset [CustomTestSet] [options...] ["説明 $v, $w"] for v in itrv, w in itrw test_ex end
@testset [CustomTestSet] [options...] ["説明"] test_func()
@testset let v = v, w = w; test_ex; end
```

# begin/end または関数呼び出しを使用した場合

@testset が使用されると、begin/end または単一の関数呼び出しで、マクロは与えられた式を評価する新しいテストセットを開始します。

カスタムテストセットタイプが指定されていない場合、デフォルトで `DefaultTestSet` が作成されます。`DefaultTestSet` はすべての結果を記録し、`Fail` または `Error` がある場合、トップレベル（非ネスト）テストセットの最後で例外をスローし、テスト結果の要約を表示します。

任意のカスタムテストセットタイプ（`AbstractTestSet` のサブタイプ）を指定でき、ネストされた `@testset` の呼び出しにも使用されます。指定されたオプションは、与えられたテストセットにのみ適用されます。デフォルトのテストセットタイプは、3つのブールオプションを受け入れます：

  * `verbose`: `true` の場合、すべてのネストされたテストセットが合格しても結果の要約が表示されます（デフォルトは `false`）。
  * `showtiming`: `true` の場合、表示される各テストセットの所要時間が表示されます（デフォルトは `true`）。
  * `failfast`: `true` の場合、テストの失敗やエラーが発生すると、テストセットとその子テストセットは即座に戻ります（デフォルトは `false`）。これは、環境変数 `JULIA_TEST_FAILFAST` を介してグローバルに設定することもできます。

!!! compat "Julia 1.8"
    `@testset test_func()` は少なくとも Julia 1.8 が必要です。


!!! compat "Julia 1.9"
    `failfast` は少なくとも Julia 1.9 が必要です。


説明文字列はループインデックスからの補間を受け入れます。説明が提供されていない場合、変数に基づいて構築されます。関数呼び出しが提供されている場合、その名前が使用されます。明示的な説明文字列はこの動作を上書きします。

デフォルトでは、`@testset` マクロはテストセットオブジェクト自体を返しますが、この動作は他のテストセットタイプでカスタマイズできます。`for` ループが使用される場合、マクロは `finish` メソッドの戻り値のリストを収集して返します。デフォルトでは、これは各イテレーションで使用されるテストセットオブジェクトのリストを返します。

`@testset` の本体の実行前に、`Random.seed!(seed)` への暗黙の呼び出しがあり、`seed` はグローバル RNG の現在のシードです。さらに、本体の実行後、グローバル RNG の状態は `@testset` の前の状態に復元されます。これは、失敗時の再現性を容易にし、グローバル RNG 状態への副作用に関係なく `@testset` のシームレスな再配置を可能にすることを目的としています。

## 例

```jldoctest; filter = r"trigonometric identities |    4      4  [0-9\.]+s"
julia> @testset "三角関数の恒等式" begin
           θ = 2/3*π
           @test sin(-θ) ≈ -sin(θ)
           @test cos(-θ) ≈ cos(θ)
           @test sin(2θ) ≈ 2*sin(θ)*cos(θ)
           @test cos(2θ) ≈ cos(θ)^2 - sin(θ)^2
       end;
テストの要約:            | 合格  合計  時間
三角関数の恒等式 |    4      4  0.2s
```

# `@testset for`

`@testset for` が使用されると、マクロは提供されたループの各イテレーションに対して新しいテストを開始します。各テストセットの意味は、`begin/end` の場合と同じです（各ループイテレーションに対して使用されるかのように）。

# `@testset let`

`@testset let` が使用されると、マクロは与えられたオブジェクトを含む透明なテストセットを開始し、そこに含まれる失敗したテストにコンテキストオブジェクトを追加します。これは、1つの大きなオブジェクトに対して関連するテストのセットを実行する際に便利で、個々のテストが失敗したときにこの大きなオブジェクトを印刷することが望ましい場合に役立ちます。透明なテストセットは、テストセット階層に追加のネストレベルを導入せず、親テストセットに直接渡されます（コンテキストオブジェクトは失敗したテストに追加されます）。

!!! compat "Julia 1.9"
    `@testset let` は少なくとも Julia 1.9 が必要です。


!!! compat "Julia 1.10"
    複数の `let` 割り当ては Julia 1.10 以降でサポートされています。


## 例

```jldoctest
julia> @testset let logi = log(im)
           @test imag(logi) == π/2
           @test !iszero(real(logi))
       end
テストは none:3 で失敗しました
  式: !(iszero(real(logi)))
     コンテキスト: logi = 0.0 + 1.5707963267948966im

ERROR: テスト中にエラーが発生しました

julia> @testset let logi = log(im), op = !iszero
           @test imag(logi) == π/2
           @test op(real(logi))
       end
テストは none:3 で失敗しました
  式: op(real(logi))
     コンテキスト: logi = 0.0 + 1.5707963267948966im
              op = !iszero

ERROR: テスト中にエラーが発生しました
```
