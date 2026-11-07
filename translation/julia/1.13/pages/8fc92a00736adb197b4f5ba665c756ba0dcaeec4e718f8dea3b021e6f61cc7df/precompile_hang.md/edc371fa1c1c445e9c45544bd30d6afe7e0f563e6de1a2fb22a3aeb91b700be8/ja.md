# Fixing precompilation hangs due to open tasks or IO

Julia 1.10 以降では、次のようなメッセージが表示されることがあります。

![プリコンパイルのハングのスクリーンショット](./img/precompilation_hang.png)

このメッセージは繰り返し表示されることがあります。自然に解消する兆しがないまま表示され続ける場合は、修正が必要な「プリコンパイルのハング」が発生している可能性があります。一時的なものであっても、ユーザーがこの警告に煩わされないように解消しておきたいかもしれません。このページでは、こうした問題の分析方法と修正方法を順に説明します。

メッセージの指示に従って `Ctrl-C` を押すと、次のように表示されることがあります。

```
^C Interrupted: Exiting precompilation...

  1 dependency had warnings during precompilation:
┌ Test1 [ac89d554-e2ba-40bc-bc5c-de68b658c982]
│  [pid 2745] Waiting for background task / IO / timer to finish:
│   Handle type        uv_handle_t->data
│   timer              0x55580decd1e0->0x7f94c3a4c340
```

このメッセージからは、次の2つの重要な情報が読み取れます。

  * ハングは `Test1` のプリコンパイル中に発生しています。これは `Test2`（`using Test2` で読み込もうとしていたパッケージ）の依存パッケージです。
  * `Test1` のプリコンパイル中に、Julia が `Timer` オブジェクトを作成し、それがまだ開いたままになっています（Timer に詳しくない場合は `?Timer` を参照してください）。これが閉じられるまで、プロセスはハングしたままです。

この情報だけで `timer = Timer(args...)` がどのように作成されているかを特定できた場合は、モジュールの最後の `end` の前に処理を追加するのがよい解決策です。`timer` がいずれ自力で終了するなら `wait(timer)` を、強制的に閉じる必要があるなら `close(timer)` を追加します。

ただし、それほど単純ではない場合もあります。通常はまず、ハングの原因が Test1 自体のコードにあるのか、それとも Test1 の依存パッケージにあるのかを調べるのが最善です。

  * 方法1：`Pkg.add("Aqua")` を実行し、[`Aqua.test_persistent_tasks`](https://juliatesting.github.io/Aqua.jl/dev/#Aqua.test_persistent_tasks-Tuple{Base.PkgId}) を使用します。これにより、問題を引き起こしているパッケージを特定できるはずです。その後、[below](@ref pchang_fix) の手順に従ってください。必要であれば、`PkgId` を `Base.PkgId(UUID("..."), "Test1")` として作成できます。ここで `...` は、`Test1/Project.toml` 内の `uuid` エントリから取得します。
  * 方法2：ハングの原因を手作業で診断します。

手作業で診断するには、次の手順を実行します。

1. `Pkg.develop("Test1")`
2. `Test1` 内で `include` によって読み込まれるコード、またはそこで定義されているコードを、`using/import` 文を*除いて*すべてコメントアウトします。
3. `using Test2`（または、そちらでもハングするのであれば `using Test1`）をもう一度試します。

ここで、結果は次のいずれかに分かれます。

  * ハングが続く場合は、[due to one of your dependencies](@ref pchang_deps) であることを示しています。
  * ハングが解消する場合は、[due to something in your code](@ref pchang_fix) であることを示しています。

## [Diagnosing and fixing hangs due to a package dependency](@id pchang_deps)

二分探索で問題のある依存パッケージを特定します。まず依存パッケージの半分をコメントアウトし、どちらの半分に原因があるかを絞り込んだら、さらにその半分をコメントアウトする、という手順を繰り返します。（プロジェクトから削除する必要はありません。`using`/`import` 文をコメントアウトするだけでかまいません。）

疑わしいパッケージを特定したら（ここでは `ThePackageYouThinkIsCausingTheProblem` と呼びます）、まずそのパッケージのプリコンパイルを試してください。そのプリコンパイル中にもハングするなら、依存関係をさらにさかのぼって問題を追跡します。

ただし、`ThePackageYouThinkIsCausingTheProblem` 自体は問題なくプリコンパイルできる可能性が高いでしょう。その場合、原因は関数 `ThePackageYouThinkIsCausingTheProblem.__init__` にあると考えられます。この関数は `ThePackageYouThinkIsCausingTheProblem` 自体のプリコンパイル中には実行されませんが、`ThePackageYouThinkIsCausingTheProblem` を読み込むパッケージでは*実行されます*。この仮説を検証するには、次のような最小動作例（MWE）を用意します。

```julia
(@v1.10) pkg> generate MWE
  Generating  project MWE:
    MWE\Project.toml
    MWE\src\MWE.jl
```

ここで、`MWE.jl` のソースコードを次のようにします。

```julia
module MWE
using ThePackageYouThinkIsCausingTheProblem
end
```

また、MWE の依存パッケージに `ThePackageYouThinkIsCausingTheProblem` を追加しておきます。

この MWE でハングが再現すれば、原因を特定できたことになります。`ThePackageYouThinkIsCausingTheProblem.__init__` が `Timer` オブジェクトを作成しているはずです。このタイマーオブジェクトに対して安全に `close` を実行できるなら、それがよい対処法です。そうでなければ、最も一般的な解決策は、*どのパッケージであっても*プリコンパイル中にはタイマーを作成しないようにすることです。次を追加してください。

```julia
ccall(:jl_generating_output, Cint, ()) == 1 && return nothing
```

これを `ThePackageYouThinkIsCausingTheProblem.__init__` の先頭行に追加すると、パッケージのプリコンパイルを目的とする Julia プロセスでは、初期化処理を一切行わなくなります。

## [Fixing package code to avoid hangs](@id pchang_fix)

パッケージ内で手がかりとなる語（今回なら「Timer」など）を検索し、どこで問題が発生しているかを特定できるか調べます。次のようなメソッドの*定義*は、それ自体では問題にならないことに注意してください。

```julia
maketimer() = Timer(timer -> println("hi"), 0; interval=1)
```

これが問題を引き起こすのは、モジュールの定義中に `maketimer` が呼び出される場合だけです。たとえば、次のようなトップレベルの文から呼び出されている可能性があります。

```julia
const GLOBAL_TIMER = maketimer()
```

また、[precompile workload](https://github.com/JuliaLang/PrecompileTools.jl) 内で呼び出されている可能性もあります。

原因となる行を特定するのが難しい場合は、二分探索を検討してください。パッケージ内のコードを部分ごとにコメントアウトして（または `include` の行をコメントアウトしてファイル全体を除外して）、問題の範囲を絞り込みます。
