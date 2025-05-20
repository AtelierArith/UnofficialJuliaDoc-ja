```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Test/docs/src/index.md"
```

# Unit Testing

```@meta
DocTestSetup = :(using Test)
```

## Testing Base Julia

Juliaは急速に開発されており、複数のプラットフォームでの機能を検証するための広範なテストスイートがあります。ソースからJuliaをビルドする場合、`make test`を使用してこのテストスイートを実行できます。バイナリインストールの場合、`Base.runtests()`を使用してテストスイートを実行できます。

```@docs
Base.runtests
```

## Basic Unit Tests

`Test` モジュールはシンプルな *単体テスト* 機能を提供します。単体テストは、結果が期待通りであることを確認することで、コードが正しいかどうかを確認する方法です。変更を加えた後でもコードが正常に動作することを確認するのに役立ち、完成時にコードが持つべき動作を指定する方法として開発中に使用することができます。また、[adding tests to your Julia Package](https://pkgdocs.julialang.org/dev/creating-packages/#Adding-tests-to-the-package) のドキュメントも参照することをお勧めします。

単純なユニットテストは、`@test` および `@test_throws` マクロを使用して実行できます：

```@docs
Test.@test
Test.@test_throws
```

例えば、新しい関数 `foo(x)` が期待通りに動作するかを確認したいとします:

```jldoctest testfoo
julia> using Test

julia> foo(x) = length(x)^2
foo (generic function with 1 method)
```

条件が真であれば、`Pass`が返されます：

```jldoctest testfoo
julia> @test foo("bar") == 9
Test Passed

julia> @test foo("fizz") >= 10
Test Passed
```

条件が偽の場合、`Fail`が返され、例外がスローされます：

```jldoctest testfoo
julia> @test foo("f") == 20
Test Failed at none:1
  Expression: foo("f") == 20
   Evaluated: 1 == 20

ERROR: There was an error during testing
```

条件が評価できなかった場合、これは `length` がシンボルに対して定義されていないために例外がスローされるため、`Error` オブジェクトが返され、例外がスローされます：

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

もし式を評価することが*例外をスローするべき*だと期待するなら、`@test_throws`を使用してこれが発生するかどうかを確認できます：

```jldoctest testfoo
julia> @test_throws MethodError foo(:cat)
Test Passed
      Thrown: MethodError
```

## Working with Test Sets

通常、大量のテストが使用されて、関数がさまざまな入力に対して正しく動作することを確認します。テストが失敗した場合、デフォルトの動作は即座に例外をスローすることです。しかし、通常は、テストの残りを最初に実行して、テストされているコードにどれだけのエラーがあるかをよりよく把握することが望ましいです。

!!! note
    `@testset`は、その中でテストを実行する際に独自のローカルスコープを作成します。


`@testset` マクロは、テストを *セット* にグループ化するために使用できます。テストセット内のすべてのテストが実行され、テストセットの最後に要約が印刷されます。テストのいずれかが失敗した場合、またはエラーにより評価できなかった場合、テストセットは `TestSetException` をスローします。

```@docs
Test.@testset
Test.TestSetException
```

`foo(x)` 関数のテストをテストセットに入れることができます:

```jldoctest testfoo; filter = r"[0-9\.]+s"
julia> @testset "Foo Tests" begin
           @test foo("a")   == 1
           @test foo("ab")  == 4
           @test foo("abc") == 9
       end;
Test Summary: | Pass  Total  Time
Foo Tests     |    3      3  0.0s
```

テストセットはネストすることもできます:

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

関数を呼び出すことに加えて：

```jldoctest testfoo; filter = r"[0-9\.]+s"
julia> f(x) = @test isone(x)
f (generic function with 1 method)

julia> @testset f(1);
Test Summary: | Pass  Total  Time
f             |    1      1  0.0s
```

これを使用すると、テストセットの因数分解が可能になり、関連する関数を実行することで個々のテストセットを実行しやすくなります。関数の場合、テストセットには呼び出された関数の名前が付けられます。ネストされたテストセットに失敗がない場合、ここで発生したように、`verbose=true`オプションが渡されない限り、要約には表示されません。

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

テストが失敗した場合、失敗したテストセットの詳細のみが表示されます：

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

[`@test_logs`](@ref) マクロを使用してログステートメントをテストすることができます。または、[`TestLogger`](@ref) を使用することもできます。

```@docs
Test.@test_logs
Test.TestLogger
Test.LogRecord
```

## Other Test Macros

浮動小数点値の計算は不正確な場合があるため、`@test a ≈ b`（ここで `≈` は `\approx` のタブ補完で入力される）を使用して近似等価性チェックを行うか、直接 [`isapprox`](@ref) を使用することができます。

```jldoctest
julia> @test 1 ≈ 0.999999999
Test Passed

julia> @test 1 ≈ 0.999999
Test Failed at none:1
  Expression: 1 ≈ 0.999999
   Evaluated: 1 ≈ 0.999999

ERROR: There was an error during testing
```

相対許容誤差と絶対許容誤差は、`≈` 比較の後に `isapprox` の `rtol` および `atol` キーワード引数を設定することで指定できます:

```jldoctest
julia> @test 1 ≈ 0.999999  rtol=1e-5
Test Passed
```

`≈`の特定の機能ではなく、むしろ`@test`マクロの一般的な機能であることに注意してください：`@test a <op> b key=val`は、マクロによって`@test op(a, b, key=val)`に変換されます。ただし、`≈`テストには特に便利です。

```@docs
Test.@inferred
Test.@test_deprecated
Test.@test_warn
Test.@test_nowarn
```

## Broken Tests

テストが一貫して失敗する場合は、`@test_broken`マクロを使用するように変更できます。これにより、テストが失敗し続ける場合は`Broken`としてマークされ、テストが成功した場合は`Error`を介してユーザーに警告が通知されます。

```@docs
Test.@test_broken
```

`@test_skip`は、評価なしでテストをスキップするためにも利用可能ですが、スキップされたテストをテストセットの報告にカウントします。テストは実行されませんが、`Broken` `Result`を返します。

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

パッケージは、`record`および`finish`メソッドを実装することで独自の`AbstractTestSet`サブタイプを作成できます。サブタイプは、説明文字列を受け取る1引数のコンストラクタを持ち、オプションはキーワード引数として渡されるべきです。

```@docs
Test.record
Test.finish
```

`Test` は、実行される際にネストされたテストセットのスタックを維持する責任を負いますが、結果の蓄積は `AbstractTestSet` サブタイプの責任です。このスタックには `get_testset` および `get_testset_depth` メソッドを使用してアクセスできます。これらの関数はエクスポートされていないことに注意してください。

```@docs
Test.get_testset
Test.get_testset_depth
```

`Test` は、ネストされた `@testset` の呼び出しが親と同じ `AbstractTestSet` サブタイプを使用することを確認します。ただし、明示的に設定されている場合を除きます。テストセットのプロパティは伝播しません。オプションの継承動作は、`Test` が提供するスタックインフラストラクチャを使用してパッケージによって実装できます。

基本的な `AbstractTestSet` サブタイプの定義は次のようになります:

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

そのテストセットは次のようになります:

```julia
@testset CustomTestSet foo=4 "custom testset inner 2" begin
    # this testset should inherit the type, but not the argument.
    @testset "custom testset inner" begin
        @test true
    end
end
```

カスタムテストセットを使用し、記録された結果を任意の外部デフォルトテストセットの一部として印刷するために、`Test.get_test_counts`を定義します。これは次のようになります:

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

前のセクションで利用可能なツールを使用して、パッケージを作成し、それにテストを追加するための潜在的なワークフローは以下の通りです。

### Generating an Example Package

このワークフローでは、`Example`というパッケージを作成します：

```julia
pkg> generate Example
shell> cd Example
shell> mkdir test
pkg> activate .
```

### Creating Sample Functions

パッケージをテストするための最も重要な要件は、テストする機能があることです。そのために、テストできるいくつかの簡単な関数を `Example` に追加します。次の内容を `src/Example.jl` に追加してください：

```julia
module Example

function greet()
    "Hello world!"
end

function simple_add(a, b)
    a + b
end

function type_multiply(a::Float64, b::Float64)
    a * b
end

export greet, simple_add, type_multiply

end
```

### Creating a Test Environment

`Example`パッケージのルートから、`test`ディレクトリに移動し、そこで新しい環境をアクティブにし、`Test`パッケージをその環境に追加します:

```julia
shell> cd test
pkg> activate .
(test) pkg> add Test
```

### Testing Our Package

今、私たちは `Example` にテストを追加する準備ができました。テストを実行したいテストセットを含む `runtests.jl` というファイルを `test` ディレクトリ内に作成するのが標準的な手法です。そのファイルを `test` ディレクトリ内に作成し、以下のコードを追加してください：

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

これらの2つの含まれるファイル、`math_tests.jl` と `greeting_tests.jl` を作成し、それらにいくつかのテストを追加する必要があります。

> **注意:** `test` 環境の `Project.toml` に `Example` を追加する必要がなかったことに注目してください。これは、Julia のテストシステムの利点であり、あなたは [read about more here](https://pkgdocs.julialang.org/dev/creating-packages/) を行うことができます。


#### Writing Tests for `math_tests.jl`

`Test.jl`の知識を活用して、`math_tests.jl`に追加できるいくつかの例のテストは次のとおりです：

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

`Test.jl`の知識を活用して、`greeting_tests.jl`に追加できるいくつかの例のテストは次のとおりです：

```julia
@testset "Testset 3" begin
    @test "Hello world!" == greet()
    @test_throws MethodError greet("Antonia")
end
```

### Testing Our Package

テストと `test` フォルダ内の `runtests.jl` スクリプトを追加したので、`Example` パッケージのルートに戻り、`Example` 環境を再アクティブ化することで、`Example` パッケージをテストできます。

```julia
shell> cd ..
pkg> activate .
```

そこから、次のようにテストスイートを実行できます。

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

すべてが正しく行われた場合、上記と似たような出力が表示されるはずです。`Test.jl`を使用すると、パッケージに対してより複雑なテストを追加できますが、これは理想的には開発者が自分で作成したパッケージのテストを始める方法を指し示すべきです。

```@meta
DocTestSetup = nothing
```

### Code Coverage

テスト中のコードカバレッジ追跡は、`pkg> test --coverage` フラグを使用して有効にできます（または、[`--code-coverage`](@ref command-line-interface) の低レベルの `julia` 引数を使用して）。これは、[julia-runtest](https://github.com/julia-actions/julia-runtest) GitHub アクションでデフォルトでオンになっています。

カバレッジを評価するには、ローカルでソースファイルの横に生成される `.cov` ファイルを手動で検査するか、CIでは [julia-processcoverage](https://github.com/julia-actions/julia-processcoverage) GitHub アクションを使用します。

!!! compat "Julia 1.11"
    Julia 1.11以降、パッケージのプリコンパイルフェーズ中にカバレッジは収集されません。

