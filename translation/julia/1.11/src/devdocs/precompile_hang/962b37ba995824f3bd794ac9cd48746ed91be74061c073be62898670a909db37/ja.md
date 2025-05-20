# Fixing precompilation hangs due to open tasks or IO

Julia 1.10 以上では、次のメッセージが表示されることがあります：

![プリコンパイルハングのスクリーンショット](./img/precompilation_hang.png)

これが繰り返される可能性があります。解決の兆しがないまま繰り返される場合、修正が必要な「プリコンパイルハング」が発生している可能性があります。一時的なものであっても、ユーザーがこの警告に悩まされないように解決することをお勧めします。このページでは、そのような問題を分析し修正する方法を説明します。

アドバイスに従って `Ctrl-C` を押すと、次のように表示されるかもしれません。

```
^C Interrupted: Exiting precompilation...

  1 dependency had warnings during precompilation:
┌ Test1 [ac89d554-e2ba-40bc-bc5c-de68b658c982]
│  [pid 2745] waiting for IO to finish:
│   Handle type        uv_handle_t->data
│   timer              0x55580decd1e0->0x7f94c3a4c340
```

このメッセージは二つの重要な情報を伝えています：

  * `Test2`を`using Test2`で読み込もうとしている際に、依存関係である`Test1`のプリコンパイル中にハングが発生しています。
  * `Test1`のプリコンパイル中に、Juliaはまだオープンな`Timer`オブジェクトを作成しました（Timersに不慣れな場合は`?Timer`を使用してください）。それが閉じるまで、プロセスはハングしています。

もしこれが `timer = Timer(args...)` がどのように作成されているかを理解するのに十分なヒントであれば、1つの良い解決策は、`timer` が最終的に自分で終了する場合は `wait(timer)` を追加するか、強制的に終了させる必要がある場合は `close(timer)` を追加することです。モジュールの最終 `end` の前に。

しかし、必ずしもそれが簡単なわけではない場合があります。通常、最良の選択肢は、ハングがTest1のコードによるものか、Test1の依存関係のいずれかによるものかを判断することから始めることです：

  * オプション 1: `Pkg.add("Aqua")` を使用し、[`Aqua.test_persistent_tasks`](https://juliatesting.github.io/Aqua.jl/dev/#Aqua.test_persistent_tasks-Tuple{Base.PkgId}) を使用してください。これにより、どのパッケージが問題を引き起こしているかを特定するのに役立ち、その後、指示 [below](@ref pchang_fix) に従う必要があります。必要に応じて、`PkgId` を `Base.PkgId(UUID("..."), "Test1")` として作成できます。ここで、`...` は `Test1/Project.toml` の `uuid` エントリから取得されます。
  * オプション2：ハングの原因を手動で診断する。

手動で診断するには：

1. `Pkg.develop("Test1")`
2. Comment out all the code `include`d or defined in `Test1`, *except* the `using/import` statements.
3. `Test2`を再度試してください（または、`Test1`を使用してもハングする場合はそれも）。

今、私たちは道の分岐点に到達しました：どちらか

  * ハングが持続しており、[due to one of your dependencies](@ref pchang_deps)であることを示しています。
  * ハングが消え、[due to something in your code](@ref pchang_fix)であることを示しています。

## [Diagnosing and fixing hangs due to a package dependency](@id pchang_deps)

バイナリサーチを使用して問題のある依存関係を特定します：まず、依存関係の半分をコメントアウトし、その後、どの半分が原因であるかを特定したら、その半分の半分をコメントアウトします。 （プロジェクトから削除する必要はなく、`using`/`import`ステートメントをコメントアウトするだけで大丈夫です。）

一度、疑わしいパッケージ（ここでは `ThePackageYouThinkIsCausingTheProblem` と呼びます）を特定したら、まずそのパッケージをプリコンパイルしてみてください。プリコンパイル中にもハングする場合は、問題を遡って追い続けてください。

しかし、おそらく `ThePackageYouThinkIsCausingTheProblem` は正常にプリコンパイルされるでしょう。これは、`ThePackageYouThinkIsCausingTheProblem.__init__` の中に問題があることを示唆しています。この関数は `ThePackageYouThinkIsCausingTheProblem` のプリコンパイル中には実行されませんが、`ThePackageYouThinkIsCausingTheProblem` を読み込む任意のパッケージでは実行されます。この理論をテストするために、最小限の動作例（MWE）を設定してください。例えば、次のようなものです。

```julia
(@v1.10) pkg> generate MWE
  Generating  project MWE:
    MWE\Project.toml
    MWE\src\MWE.jl
```

`MWE.jl`のソースコードはどこにありますか？

```julia
module MWE
using ThePackageYouThinkIsCausingTheProblem
end
```

そして、`ThePackageYouThinkIsCausingTheProblem`をMWEの依存関係に追加しました。

そのMWEがハングを再現する場合、あなたは原因を特定しました: `ThePackageYouThinkIsCausingTheProblem.__init__` が `Timer` オブジェクトを作成しているに違いありません。タイマーオブジェクトを安全に `close` できる場合、それは良い選択です。そうでない場合、最も一般的な解決策は、*任意の* パッケージがプリコンパイルされている間にタイマーを作成しないことです: 追加してください

```julia
ccall(:jl_generating_output, Cint, ()) == 1 && return nothing
```

`ThePackageYouThinkIsCausingTheProblem.__init__`の最初の行として、パッケージをプリコンパイルする目的のJuliaプロセスでの初期化を回避します。

## [Fixing package code to avoid hangs](@id pchang_fix)

パッケージ内で示唆的な単語（ここでは「Timer」のような）を検索し、問題がどこで発生しているかを特定できるか確認してください。メソッドの*定義*のようなものに注意してください。

```julia
maketimer() = Timer(timer -> println("hi"), 0; interval=1)
```

それ自体は問題ではありません：`maketimer` がモジュールが定義されている間に呼び出される場合にのみ、この問題を引き起こす可能性があります。これは、次のようなトップレベルのステートメントから発生している可能性があります。

```julia
const GLOBAL_TIMER = maketimer()
```

または、[precompile workload](https://github.com/JuliaLang/PrecompileTools.jl)で発生する可能性があります。

原因となる行を特定するのに苦労している場合は、バイナリサーチを行うことを検討してください：パッケージのセクションをコメントアウトする（または、全ファイルを省略するために `include` 行を使用する）ことで、問題の範囲を縮小するまで続けてください。
