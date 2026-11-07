```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Test/docs/src/index.md"
```

# Unit Testing

```@meta
DocTestSetup = :(using Test)
```

## Testing Base Julia

Julia は現在も急速に開発が進められており、複数のプラットフォームで機能を検証するための広範なテストスイートを備えています。ソースから Julia をビルドした場合は、`make test` を使ってこのテストスイートを実行できます。バイナリ版をインストールした場合は、`Base.runtests()` を使って実行できます。

```@docs
Base.runtests
```

## Basic Unit Tests

`Test` モジュールは、シンプルな*ユニットテスト*機能を提供します。ユニットテストとは、結果が期待どおりであることを確認して、コードが正しいかどうかを調べる方法です。変更後もコードが引き続き動作することを確認するのに役立ちます。また、開発時に、完成したコードが備えるべき動作を指定するためにも利用できます。[adding tests to your Julia Package](https://pkgdocs.julialang.org/dev/creating-packages/#adding-tests-to-packages) のドキュメントも参照してください。

`@test` マクロと `@test_throws` マクロを使うと、簡単なユニットテストを実行できます。

```@docs
Test.@test
Test.@test_throws
```

たとえば、新しい関数 `foo(x)` が期待どおりに動作することを確認したいとします。

```jldoctest testfoo
julia> using Test

julia> foo(x) = length(x)^2
foo (generic function with 1 method)
```

条件が真の場合は、`Pass` が返されます。

```jldoctest testfoo
julia> @test foo("bar") == 9
Test Passed

julia> @test foo("fizz") >= 10
Test Passed
```

条件が偽の場合は、`Fail` が返され、例外がスローされます。

```jldoctest testfoo
julia> @test foo("f") == 20
Test Failed at none:1
  Expression: foo("f") == 20
   Evaluated: 1 == 20
ERROR: There was an error during testing
```

この例では、`length` がシンボルに対して定義されていないために例外がスローされ、条件を評価できなかった場合、`Error` オブジェクトが返され、例外がスローされます。

```julia-repl
julia> @test foo(:cat) == 1
Error During Test
  Test threw an exception of type MethodError
  Expression: foo(:cat) == 1
  MethodError: no method matching length(::Symbol)
  The function `length` exists, but no method is defined for this combination of argument types.

  Closest candidates are:
    length(::SimpleVector) at essentials.jl:256
    length(::Base.MethodList) at reflection.jl:521
    length(::MethodTable) at reflection.jl:597
    ...
  Stacktrace:
  [...]
ERROR: There was an error during testing
```

式の評価で例外が*発生するはず*だと予想される場合は、`@test_throws` を使って、実際に例外が発生することを確認できます。

```jldoctest testfoo
julia> @test_throws MethodError foo(:cat)
Test Passed
      Thrown: MethodError
```

## Working with Test Sets

通常、さまざまな入力に対して関数が正しく動作することを確認するため、多数のテストを実行します。テストが失敗した場合、デフォルトでは直ちに例外がスローされます。しかし、テスト対象のコードにどれほどのエラーがあるかを把握するには、残りのテストも実行してから結果を確認するほうが望ましい場合がほとんどです。

!!! note
    `@testset` は、その中のテストを実行する際に独自のローカルスコープを作成します。


`@testset` マクロを使うと、テストを*セット*にまとめられます。テストセット内のテストはすべて実行され、セットの最後に概要が出力されます。テストが失敗した場合、またはエラーのために評価できなかった場合は、テストセットから `TestSetException` がスローされます。

```@docs
Test.@testset
Test.TestSetException
```

`foo(x)` 関数のテストを、テストセットにまとめることができます。

```jldoctest testfoo; filter = r"[0-9\.]+s"
julia> @testset "Foo Tests" begin
           @test foo("a")   == 1
           @test foo("ab")  == 4
           @test foo("abc") == 9
       end;
Test Summary: | Pass  Total  Time
Foo Tests     |    3      3  0.0s
```

テストセットは入れ子にすることもできます。

```jldoctest testfoo; filter = r"[0-9\.]+s"
julia> @testset "Foo Tests" begin
           @testset "Animals" begin
               @test foo("cat") == 9
               @test foo("dog") == foo("cat")
           end
           @testset "Arrays $i" for i in 1:3
               @test foo(zeros(i)) == i^2
               @test foo(fill(1.0, i)) == i^2
           end
       end;
Test Summary: | Pass  Total  Time
Foo Tests     |    8      8  0.0s
```

関数を呼び出すこともできます。

```jldoctest testfoo; filter = r"[0-9\.]+s"
julia> f(x) = @test isone(x)
f (generic function with 1 method)

julia> @testset f(1);
Test Summary: | Pass  Total  Time
f             |    1      1  0.0s
```

この方法を使うと、テストセットを関数に分割できるため、対応する関数を実行して個々のテストセットを実行しやすくなります。関数を呼び出した場合、テストセットには呼び出された関数の名前が付けられます。ここでの例のように、入れ子になったテストセットで失敗がなければ、概要には表示されません。表示するには、`verbose=true` オプションを渡します。

```jldoctest testfoo; filter = r"[0-9\.]+s"
julia> @testset verbose = true "Foo Tests" begin
           @testset "Animals" begin
               @test foo("cat") == 9
               @test foo("dog") == foo("cat")
           end
           @testset "Arrays $i" for i in 1:3
               @test foo(zeros(i)) == i^2
               @test foo(fill(1.0, i)) == i^2
           end
       end;
Test Summary: | Pass  Total  Time
Foo Tests     |    8      8  0.0s
  Animals     |    2      2  0.0s
  Arrays 1    |    2      2  0.0s
  Arrays 2    |    2      2  0.0s
  Arrays 3    |    2      2  0.0s
```

### Environment Variable Support

`Test` モジュールでは、`JULIA_TEST_VERBOSE` 環境変数を使って、詳細出力の動作を全体的に制御できます。

  * `JULIA_TEST_VERBOSE=true` の場合、テストセットではデフォルトで `verbose=true` が使われます。また、テストセットの開始時と終了時に、所要時間を含む「Starting testset」と「Finished testset」のメッセージが出力されます。
  * `JULIA_TEST_VERBOSE=false` の場合、または環境変数が設定されていない場合、テストセットではデフォルトで `verbose=false` が使われ、開始・終了メッセージは出力されません。

この環境変数を使うと、テストコードを変更せずにテストスイートの詳細な出力を有効にできるため、デバッグに便利です。

```julia
$ JULIA_TEST_VERBOSE=true julia -e '
using Test
@testset "Example" begin
    @test 1 + 1 == 2
    @testset "Nested" begin
        @test 2 * 2 == 4
    end
end'

Starting testset: Example
  Starting testset: Nested
  Finished testset: Nested (0.0s)
Finished testset: Example (0.0s)
Test Summary: | Pass  Total  Time
Example       |    2      2  0.0s
  Nested      |    1      1  0.0s
```

テストが失敗した場合は、失敗したテストセットの詳細だけが表示されます。

```julia-repl; filter = r"[0-9\.]+s"
julia> @testset "Foo Tests" begin
           @testset "Animals" begin
               @testset "Felines" begin
                   @test foo("cat") == 9
               end
               @testset "Canines" begin
                   @test foo("dog") == 9
               end
           end
           @testset "Arrays" begin
               @test foo(zeros(2)) == 4
               @test foo(fill(1.0, 4)) == 15
           end
       end

Arrays: Test Failed
  Expression: foo(fill(1.0, 4)) == 15
   Evaluated: 16 == 15
[...]
Test Summary: | Pass  Fail  Total  Time
Foo Tests     |    3     1      4  0.0s
  Animals     |    2            2  0.0s
  Arrays      |    1     1      2  0.0s
ERROR: Some tests did not pass: 3 passed, 1 failed, 0 errored, 0 broken.
```

## Testing Log Statements

ログ出力をテストするには [`@test_logs`](@ref) マクロを使うか、[`TestLogger`](@ref) を使います。

```@docs
Test.@test_logs
Test.TestLogger
Test.LogRecord
```

## Other Test Macros

浮動小数点値を使った計算には誤差が生じることがあるため、`@test a ≈ b` を使って近似的な等価性を確認できます。このとき、`≈` は `\approx` のタブ補完で入力できる [`isapprox`](@ref) 関数です。または、[`isapprox`](@ref) を直接使うこともできます。

```jldoctest
julia> @test 1 ≈ 0.999999999
Test Passed

julia> @test 1 ≈ 0.999999
Test Failed at none:1
  Expression: 1 ≈ 0.999999
ERROR: There was an error during testing
```

`isapprox` のキーワード引数 `rtol` と `atol` を設定すると、それぞれ相対許容誤差と絶対許容誤差を指定できます。比較演算子 `≈` の後に指定します。

```jldoctest
julia> @test 1 ≈ 0.999999  rtol=1e-5
Test Passed
```

これは `≈` 固有の機能ではなく、`@test` マクロ全般の機能です。マクロによって `@test a <op> b key=val` は `@test op(a, b, key=val)` に変換されます。ただし、`≈` のテストでは特に便利です。

```@docs
Test.@inferred
Test.@test_deprecated
Test.@test_warn
Test.@test_nowarn
```

## Broken Tests

テストが一貫して失敗する場合は、`@test_broken` マクロを使うように変更できます。失敗が続く場合はテストを `Broken` として扱い、成功した場合は `Error` を通じてユーザーに通知します。

```@docs
Test.@test_broken
```

`@test_skip` を使うと、評価せずにテストをスキップできます。スキップしたテストもテストセットの集計には含まれます。テストは実行されませんが、`Broken` `Result` が表示されます。

```@docs
Test.@test_skip
```

## Test result types

```@docs
Test.Result
Test.Pass
Test.Fail
Test.Error
Test.Broken
```

## Creating Custom `AbstractTestSet` Types

パッケージでは、`record` メソッドと `finish` メソッドを実装することで、独自の `AbstractTestSet` サブタイプを作成できます。このサブタイプには、説明文字列を受け取る1引数コンストラクターを用意し、オプションはキーワード引数として渡します。

```@docs
Test.record
Test.finish
```

`Test` は、テストセットの実行中に入れ子になったテストセットのスタックを管理します。一方、結果の蓄積は `AbstractTestSet` サブタイプ側で行う必要があります。`get_testset` メソッドと `get_testset_depth` メソッドを使うと、このスタックにアクセスできます。これらの関数はエクスポートされていないことに注意してください。

```@docs
Test.get_testset
Test.get_testset_depth
```

`Test` は、入れ子になった `@testset` の呼び出しで、明示的に指定されていない限り、親と同じ `AbstractTestSet` サブタイプが使われるようにします。ただし、テストセットのプロパティは引き継ぎません。オプションの継承動作は、`Test` が提供するスタック機構を使って、パッケージ側で実装できます。

基本的な `AbstractTestSet` サブタイプは、次のように定義できます。

```julia
import Test: Test, record, finish
using Test: AbstractTestSet, Result, Pass, Fail, Error
using Test: get_testset_depth, get_testset
struct CustomTestSet <: Test.AbstractTestSet
    description::AbstractString
    foo::Int
    results::Vector
    # constructor takes a description string and options keyword arguments
    CustomTestSet(desc; foo=1) = new(desc, foo, [])
end

record(ts::CustomTestSet, child::AbstractTestSet) = push!(ts.results, child)
record(ts::CustomTestSet, res::Result) = push!(ts.results, res)
function finish(ts::CustomTestSet)
    # just record if we're not the top-level parent
    if get_testset_depth() > 0
        record(get_testset(), ts)
        return ts
    end

    # so the results are printed if we are at the top level
    Test.print_test_results(ts)
    return ts
end
```

このテストセットは、次のように使います。

```julia
@testset CustomTestSet foo=4 "custom testset inner 2" begin
    # this testset should inherit the type, but not the argument.
    @testset "custom testset inner" begin
        @test true
    end
end
```

カスタムテストセットを使い、記録された結果を外側のデフォルトテストセットの一部として出力するには、`Test.get_test_counts` も定義します。たとえば、次のようになります。

```julia
using Test: AbstractTestSet, Pass, Fail, Error, Broken, get_test_counts, TestCounts, format_duration

function Test.get_test_counts(ts::CustomTestSet)
    passes, fails, errors, broken = 0, 0, 0, 0
    # cumulative results
    c_passes, c_fails, c_errors, c_broken = 0, 0, 0, 0

    for t in ts.results
        # count up results
        isa(t, Pass)   && (passes += 1)
        isa(t, Fail)   && (fails  += 1)
        isa(t, Error)  && (errors += 1)
        isa(t, Broken) && (broken += 1)
        # handle children
        if isa(t, AbstractTestSet)
            tc = get_test_counts(t)::TestCounts
            c_passes += tc.passes + tc.cumulative_passes
            c_fails  += tc.fails + tc.cumulative_fails
            c_errors += tc.errors + tc.cumulative_errors
            c_broken += tc.broken + tc.cumulative_broken
        end
    end
    # get a duration, if we have one
    duration = format_duration(ts)
    return TestCounts(true, passes, fails, errors, broken, c_passes, c_fails, c_errors, c_broken, duration)
end
```

```@docs
Test.TestCounts
Test.get_test_counts
Test.format_duration
Test.print_test_results
```

## Test utilities

```@docs
Test.GenericArray
Test.GenericDict
Test.GenericOrder
Test.GenericSet
Test.GenericString
Test.detect_ambiguities
Test.detect_unbound_args
```

## Workflow for Testing Packages

前のセクションで紹介したツールを使って、パッケージを作成し、テストを追加する際のワークフローの例を見てみましょう。

### Generating an Example Package

このワークフローでは、`Example` という名前のパッケージを作成します。

```julia
pkg> generate Example
shell> cd Example
shell> mkdir test
pkg> activate .
```

### Creating Sample Functions

パッケージをテストするには、まずテスト対象となる機能が必要です。そこで、テストできる簡単な関数を `Example` に追加します。次の内容を `src/Example.jl` に追加してください。

```julia
module Example

export greet, simple_add, type_multiply

function greet()
    "Hello world!"
end

function simple_add(a, b)
    a + b
end

function type_multiply(a::Float64, b::Float64)
    a * b
end

end
```

### Creating a Test Environment

`Example` パッケージのルートディレクトリから `test` ディレクトリに移動し、そこで新しい環境を有効化して、`Test` パッケージを環境に追加します。

```julia
shell> cd test
pkg> activate .
(test) pkg> add Test
```

### Testing Our Package

これで、`Example` にテストを追加する準備ができました。実行するテストセットを記述した `runtests.jl` というファイルを `test` ディレクトリ内に作成するのが一般的です。`test` ディレクトリ内にこのファイルを作成し、次のコードを追加してください。

```julia
using Example
using Test

@testset "Example tests" begin

    @testset "Math tests" begin
        include("math_tests.jl")
    end

    @testset "Greeting tests" begin
        include("greeting_tests.jl")
    end
end
```

インクルードする2つのファイル、`math_tests.jl` と `greeting_tests.jl` を作成し、それぞれにテストを追加します。

> **注:** `test` 環境の `Project.toml` に `Example` を追加する必要がなかった点に注目してください。これは Julia のテストシステムの利点の一つであり、[read about more here](https://pkgdocs.julialang.org/dev/creating-packages/) できます。


#### Writing Tests for `math_tests.jl`

`Test.jl` の知識を使って、`math_tests.jl` に追加できるテストの例を示します。

```julia
@testset "Testset 1" begin
    @test 2 == simple_add(1, 1)
    @test 3.5 == simple_add(1, 2.5)
    @test_throws MethodError simple_add(1, "A")
    @test_throws MethodError simple_add(1, 2, 3)
end

@testset "Testset 2" begin
    @test 1.0 == type_multiply(1.0, 1.0)
    @test isa(type_multiply(2.0, 2.0), Float64)
    @test_throws MethodError type_multiply(1, 2.5)
end
```

#### Writing Tests for `greeting_tests.jl`

`Test.jl` の知識を使って、`greeting_tests.jl` に追加できるテストの例を示します。

```julia
@testset "Testset 3" begin
    @test "Hello world!" == greet()
    @test_throws MethodError greet("Antonia")
end
```

### Testing Our Package

テストと `test` 内の `runtests.jl` スクリプトを追加したので、`Example` パッケージのルートに戻り、`Example` 環境を再度有効化すれば、`Example` パッケージをテストできます。

```julia
shell> cd ..
pkg> activate .
```

その後、次のようにテストスイートを実行します。

```julia
(Example) pkg> test
     Testing Example
      Status `/tmp/jl_Yngpvy/Project.toml`
  [fa318bd2] Example v0.1.0 `/home/src/Projects/tmp/errata/Example`
  [8dfed614] Test `@stdlib/Test`
      Status `/tmp/jl_Yngpvy/Manifest.toml`
  [fa318bd2] Example v0.1.0 `/home/src/Projects/tmp/errata/Example`
  [2a0f44e3] Base64 `@stdlib/Base64`
  [b77e0a4c] InteractiveUtils `@stdlib/InteractiveUtils`
  [56ddb016] Logging `@stdlib/Logging`
  [d6f4376e] Markdown `@stdlib/Markdown`
  [9a3f8284] Random `@stdlib/Random`
  [ea8e919c] SHA `@stdlib/SHA`
  [9e88b42a] Serialization `@stdlib/Serialization`
  [8dfed614] Test `@stdlib/Test`
     Testing Running tests...
Test Summary: | Pass  Total
Example tests |    9      9
     Testing Example tests passed
```

すべて正しく実行できていれば、上記と同様の出力が表示されます。`Test.jl` を使えば、パッケージにさらに複雑なテストを追加できます。この例が、開発者が自作パッケージのテストを始める際の参考になれば幸いです。

```@meta
DocTestSetup = nothing
```

### Code Coverage

テスト中のコードカバレッジ追跡は、`pkg> test --coverage` フラグを使って有効にできます（より低いレベルでは、julia の引数 [`--code-coverage`](@ref command-line-interface) を使います）。[julia-runtest](https://github.com/julia-actions/julia-runtest) GitHub アクションでは、デフォルトで有効になっています。

カバレッジを評価するには、ローカルではソースファイルの隣に生成される `.cov` ファイルを手動で確認するか、CI では [julia-processcoverage](https://github.com/julia-actions/julia-processcoverage) GitHub アクションを使います。

!!! compat "Julia 1.11"
    Julia 1.11 以降、パッケージのプリコンパイル中にはカバレッジが収集されません。

