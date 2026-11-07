```julia
@testset [CustomTestSet] [options...] ["description"] begin test_ex end
@testset [CustomTestSet] [options...] ["description $v"] for v in itr test_ex end
@testset [CustomTestSet] [options...] ["description $v, $w"] for v in itrv, w in itrw test_ex end
@testset [CustomTestSet] [options...] ["description"] test_func()
@testset let v = v, w = w; test_ex; end
```

# With begin/end or function call

@testset を begin/end または単一の関数呼び出しとともに使用すると、このマクロは新しいテストセットを開始し、指定された式を評価します。

カスタムのテストセット型が指定されていない場合、デフォルトでは `DefaultTestSet` が作成されます。`DefaultTestSet` はすべての結果を記録し、`Fail` または `Error` がある場合は、最上位（ネストされていない）テストセットの終了時に、テスト結果の概要とともに例外をスローします。

任意のカスタムテストセット型（`AbstractTestSet` のサブタイプ）を指定できます。その型は、ネストされた `@testset` の呼び出しにも使用されます。指定したオプションが適用されるのは、そのオプションを指定したテストセットだけです。デフォルトのテストセット型では、次のオプションを指定できます。

  * `verbose::Bool`: `true` の場合、ネストされたテストセットがすべて成功していても、その結果の概要を表示します（デフォルトは `false`）。
  * `showtiming::Bool`: `true` の場合、表示される各テストセットの実行時間を表示します（デフォルトは `true`）。
  * `failfast::Bool`: `true` の場合、テストの失敗またはエラーが発生すると、テストセットとその子テストセットは直ちに処理を終了します（デフォルトは `false`）。環境変数 `JULIA_TEST_FAILFAST` を使って、グローバルに設定することもできます。
  * `rng::Random.AbstractRNG`: 指定した乱数生成器（RNG）を、テストセットのグローバルな乱数生成器として使用します。`rng` は `copy!` 可能でなければなりません。このオプションは、グローバル RNG の状態にのみ依存する確率的なテスト失敗を、局所的に再現する場合に役立ちます。

!!! compat "Julia 1.8"
    `@testset test_func()` を使用するには、Julia 1.8 以降が必要です。


!!! compat "Julia 1.9"
    `failfast` を使用するには、Julia 1.9 以降が必要です。


!!! compat "Julia 1.12"
    `rng` オプションを使用するには、Julia 1.12 以降が必要です。


説明文字列では、ループのインデックスを補間できます。説明が指定されていない場合は、変数に基づいて説明が生成されます。関数呼び出しが指定されている場合は、その関数名が使われます。明示的に指定した説明文字列は、これらの動作より優先されます。

デフォルトでは、`@testset` マクロはテストセットオブジェクト自体を返しますが、この動作は他のテストセット型で変更できます。`for` ループを使用すると、マクロは `finish` メソッドの戻り値を集めてリストとして返します。このメソッドはデフォルトで、各反復で使用されたテストセットオブジェクトのリストを返します。

`@testset` の本体を実行する前に、`copy!(Random.default_rng(), rng)` が暗黙的に呼び出されます。このときの `rng` は、現在のタスクの RNG、または `rng` オプションで渡された値です。また、本体の実行後には、グローバル RNG の状態が `@testset` の実行前の状態に復元されます。これは、失敗時の再現性を高めるとともに、グローバル RNG の状態に対する副作用にかかわらず、`@testset` を自由に並べ替えられるようにするためです。

!!! note "ネストされたテストセットの RNG"
    `rng` オプションで変更しない限り、すべてのネストされたテストセットの開始時に同じ RNG が設定されます。テストセットで失敗が発生したときに画面に表示される RNG は、内側のテストセットにユーザーが異なる RNG を手動で設定していても、最外側のテストセットのグローバル RNG です。


## Examples

```jldoctest; filter = r"trigonometric identities |    4      4  [0-9\.]+s"
julia> @testset "trigonometric identities" begin
           θ = 2/3*π
           @test sin(-θ) ≈ -sin(θ)
           @test cos(-θ) ≈ cos(θ)
           @test sin(2θ) ≈ 2*sin(θ)*cos(θ)
           @test cos(2θ) ≈ cos(θ)^2 - sin(θ)^2
       end;
Test Summary:            | Pass  Total  Time
trigonometric identities |    4      4  0.2s
```

# `@testset for`

`@testset for` を使用すると、指定したループの反復ごとに新しいテストセットが開始されます。それ以外の各テストセットの動作は、`begin/end` の場合と同じです（各ループ反復で使用した場合と同様です）。

# `@testset let`

`@testset let` を使用すると、指定したオブジェクトをコンテキストオブジェクトとして追加する、*透過的な*テストセットが開始されます。このテストセット内で失敗またはエラーになったテストには、そのオブジェクトが付加されます。これは、より大きなオブジェクトに関連する一連のテストを実行し、個々のテストが失敗したときにその大きなオブジェクトも表示したい場合に便利です。透過的なテストセットは、テストセット階層に新たなネストレベルを追加せず、親テストセットにそのまま渡されます（失敗したテストにはコンテキストオブジェクトが追加されます）。

!!! compat "Julia 1.9"
    `@testset let` を使用するには、Julia 1.9 以降が必要です。


!!! compat "Julia 1.10"
    複数の `let` の割り当ては、Julia 1.10 以降でサポートされています。


!!! compat "Julia 1.13"
    テストでエラーが発生した場合にも、Julia 1.13 以降ではコンテキストが表示されます。


# Special implicit world age increment for `@testset begin` and `@testset for`

`@testset begin` 内、および `@testset for` のループ本体内では、各文の後にワールドエイジが暗黙的に進みます。これは通常のトップレベルコードと同じ動作ですが、通常の `begin/end` ブロックや `for` ループとは異なります。つまり、ワールドエイジに関しては、`@testset begin` と `@testset for` は、本体がトップレベルに記述されているかのように動作します。

## Examples

```jldoctest
julia> @testset let logi = log(im)
           @test imag(logi) == π/2
           @test !iszero(real(logi))
       end
Test Failed at none:3
  Expression: !(iszero(real(logi)))
   Evaluated: !(iszero(0.0))
     Context: logi = 0.0 + 1.5707963267948966im
ERROR: There was an error during testing

julia> @testset let logi = log(im), op = !iszero
           @test imag(logi) == π/2
           @test op(real(logi))
       end
Test Failed at none:3
  Expression: op(real(logi))
   Evaluated: op(0.0)
     Context: logi = 0.0 + 1.5707963267948966im
              op = !iszero
ERROR: There was an error during testing
```
