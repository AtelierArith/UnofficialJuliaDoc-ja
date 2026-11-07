```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/NEWS.md"
```

# Julia v1.13 Release Notes

## New language features

  * 最も内側で囲んでいる関数を参照する新しい`@__FUNCTION__`マクロ（[#58940](https://github.com/JuliaLang/julia/issues/58940)）。
  * Unicode 16で新たに追加された文字U+1F8B2 🢲（RIGHTWARDS ARROW WITH LOWER HOOK）が、矢印の優先順位を持つ有効な演算子になりました。REPLでは`\hookunderrightarrow`として入力できます（[JuliaLang/JuliaSyntax.jl#525]、[#57143](https://github.com/JuliaLang/julia/issues/57143)）。
  * Unicode 17をサポート（[#59534](https://github.com/JuliaLang/julia/issues/59534)）。

## Language changes

  * `@doc`の戻り値が変更されました。以前のバージョンのように`Docs.Binding`オブジェクトを返すのではなく、ドキュメントに記載された式（関数や型など）を返すようになりました。`@doc`が`Docs.Binding`を返すことに依存していたコードは、更新が必要です（[#59882](https://github.com/JuliaLang/julia/issues/59882)、[#60681](https://github.com/JuliaLang/julia/issues/60681)）。
  * `hash`のアルゴリズムと戻り値が、一部の型、特に`AbstractString`で変更されました。変更対象と同じ型に対する`hash`の特殊化（サードパーティ製文字列パッケージの一部など）は、削除が必要になる場合があります（[#57509](https://github.com/JuliaLang/julia/issues/57509)、[#59691](https://github.com/JuliaLang/julia/issues/59691)）。
  * `hash(::AbstractString)`関数は、`codeunit`関数と`iterate`関数を正しく実装することで、コピーもコストも発生しない関数になりました。サードパーティ製文字列パッケージでは、既存の`hash`関数のオーバーライドを削除し、新しいアルゴリズムに移行してください（[#59691](https://github.com/JuliaLang/julia/issues/59691)）。

## Command-line option changes

  * オプション`--sysimage-native-code=no`は非推奨になりました。
  * 環境変数`JULIA_CPU_TARGET`で、現在のシステムイメージのビルドに使用されたCPUターゲットに一致する（またはそれを拡張する）ためのキーワード`sysimage`が使えるようになりました（[#58970](https://github.com/JuliaLang/julia/issues/58970)）。
  * `--code-coverage=all`オプションは、システムイメージ内のメソッドのコードカバレッジを正確に測定できるよう、システムイメージのキャッシュを自動的に破棄するようになりました。キャッシュは起動後（startup.jlの実行後）、ユーザーコードの実行前に破棄されます（[#59234](https://github.com/JuliaLang/julia/issues/59234)）。
  * トップレベル評価中に評価される式を表示する、新しいコマンドラインオプション`--trace-eval`が追加されました。`--trace-eval=loc`または単に`--trace-eval`（位置のみ表示）、`--trace-eval=full`（式全体を表示）、`--trace-eval=no`（トレースを無効化）を指定できます。また、コマンドラインオプションより優先されるグローバル制御`Base.TRACE_EVAL`も追加されました。これは`:no`、`:loc`、`:full`、または`nothing`（コマンドライン設定を使用）に設定できます（[#57137](https://github.com/JuliaLang/julia/issues/57137)）。
  * CIデバッグが有効になった場合、Juliaは詳細なデバッグオプション（`--trace-eval`および`JULIA_TEST_VERBOSE`）を自動的に有効にするようになりました。たとえば、GitHub Actionsの再実行時に「debug logging」UIトグルを有効にした場合です。他のプラットフォームにも対応しています（[#59551](https://github.com/JuliaLang/julia/issues/59551)）。

## Multi-threading changes

  * `SpinLock <: AbstractSpinLock`を使った新しい`AbstractSpinLock`が定義されました（[#55944](https://github.com/JuliaLang/julia/issues/55944)）。
  * 新しい`PaddedSpinLock <: AbstractSpinLock`が定義されました。誤共有を避けるため、追加のパディングが設けられています（[#55944](https://github.com/JuliaLang/julia/issues/55944)）。
  * Apple Siliconでは、`Sys.CPU_THREADS`と`Sys.EFFECTIVE_CPU_THREADS`が、高性能コアの層だけでなく、すべてのCPUコアを数えるようになりました。これにより、次のデフォルト設定が影響を受けます。`--threads=auto`（`JULIA_NUM_THREADS=auto`）、`--gcthreads`のデフォルト、`--procs=auto`、`Distributed.addprocs()`、`JULIA_NUM_PRECOMPILE_TASKS`。検出されたコア数を上書きするには、`JULIA_CPU_THREADS`を設定してください。パフォーマンスコアを判定するヒューリスティックは改善され、LinearAlgebraに移されました。引き続き、BLASスレッドプールのデフォルトサイズの決定に使われます（[#62891](https://github.com/JuliaLang/julia/issues/62891)、[JuliaLang/LinearAlgebra.jl#1686](https://github.com/JuliaLang/LinearAlgebra.jl/pull/1686)）。

## New library functions

  * `Base.acquire(f, s::Base.Semaphore)`の非クロージャ版である`Base.@acquire`マクロが追加されました。`@lock`に似ています（[#56845](https://github.com/JuliaLang/julia/issues/56845)）。
  * 汎用イテラブルの`n`番目の要素にアクセスする`nth`関数が追加されました（[#56580](https://github.com/JuliaLang/julia/issues/56580)）。
  * パフォーマンスと利便性のため、`ispositive(::Real)`と`isnegative(::Real)`が提供されます（[#53677](https://github.com/JuliaLang/julia/issues/53677)）。
  * 構造体のフィールドのインデックスを取得する`fieldindex`関数がエクスポートされるようになりました（[#58119](https://github.com/JuliaLang/julia/issues/58119)）。
  * `Base.donotdelete`が公開APIになりました。引数がデッドコード除去されるのを防ぎます（[#55774](https://github.com/JuliaLang/julia/issues/55774)）。
  * `Sys.sysimage_target()`は、現在のシステムイメージのビルドに使用されたCPUターゲット文字列を返します（[#58970](https://github.com/JuliaLang/julia/issues/58970)）。
  * `Iterators.findeach`は、`findall`の遅延評価版です（[#54124](https://github.com/JuliaLang/julia/issues/54124)）。

## New library features

  * `fieldoffset`は、`fieldtype`と同様に、フィールド名をシンボルとしても受け取れるようになりました（[#58100](https://github.com/JuliaLang/julia/issues/58100)）。
  * `sort(keys(::Dict))`と`sort(values(::Dict))`は、自動的にコレクトするようになりました。以前は例外をスローしていました（[#56978](https://github.com/JuliaLang/julia/issues/56978)）。
  * 1始まりの軸のスーパータイプとして`Base.AbstractOneTo`が追加され、そのサブタイプとして`Base.OneTo`が定義されました（[#56902](https://github.com/JuliaLang/julia/issues/56902)）。
  * `takestring!(::IOBuffer)`はバッファーの内容を取り除き、その内容を`String`として返します。
  * `chopprefix`と`chopsuffix`は、削除する接頭辞／接尾辞として`AbstractChar`も受け取れるようになりました。
  * `macroexpand`関数（デフォルトはtrue）と、新しい`macroexpand!`関数（デフォルトはfalse）で、結果に対して従来のスコープ解決処理を実行するかどうかを制御する、ブール値のキーワード引数`legacyscope`が使えるようになりました。従来のスコープ解決コードには既知の設計上の問題があり、将来のバージョンではデフォルトで無効になります。今のうちに`legacyscope=false`を呼び出すか、`macroexpand!`を使って移行してください。そのためには、`macroexpand`を`Meta.unescape`および`Meta.reescape`とともに呼び出すコードの修正や、結果に`hygienic-scope`または`escape`マーカーが現れることを想定したテストへの更新が必要になる場合があります。
  * コールバック`OncePerProcess{T}`を使ってデフォルト値を計算するスコープ付き値のために、`Base.ScopedValues.LazyScopedValue{T}`が導入されました。これにより、デフォルト値を遅延初期化できます。`AbstractScopedValue`は、`ScopedValue`と`LazyScopedValue`の両方に共通する抽象基底型になりました（[#59372](https://github.com/JuliaLang/julia/issues/59372)）。
  * アクティブなマニフェストのパスを返す新しい関数`Base.active_manifest()`が追加されました。`Base.active_project()`と同様に、指定したプロジェクトファイルで使用されるマニフェストも返せます（[#57937](https://github.com/JuliaLang/julia/issues/57937)）。

## Standard library changes

  * `mod(x::AbstractFloat, -Inf)`は、`x`が有限であれば、`x`を返すようになりました。これはC標準に準拠する変更であり、バグ修正とみなされます（[#47102](https://github.com/JuliaLang/julia/issues/47102)）。
  * `ReinterpretArray`に対する、インデックスを指定しない`getindex`および`setindex!`（つまり`A[]`）は、要素が複数ある場合に正しく`BoundsError`をスローするようになりました（[#58814](https://github.com/JuliaLang/julia/issues/58814)）。
  * `randperm!`と`randcycle!`は、`Array`ではない`AbstractArray`入力もサポートするようになりました。ただし、入力は変更可能で、インデックスが1始まりである必要があります（[#58596](https://github.com/JuliaLang/julia/issues/58596)）。
  * `shuffle`は、`NTuple`引数を受け取れるようになりました（[#56906](https://github.com/JuliaLang/julia/issues/56906)）。

#### REPL

  * Julia REPLがWindowsでブラケット付きペーストに対応しました。これにより、大きなコードブロックをREPLに貼り付ける速度が大幅に向上するはずです（[#59825](https://github.com/JuliaLang/julia/issues/59825)）。
  * REPLで、入力中の構文ハイライトが表示されるようになりました。カスタマイズについてはREPLのドキュメントを参照してください。
  * REPLで、閉じ括弧、閉じ丸括弧、閉じ引用符が自動挿入されるようになりました。カスタマイズについてはREPLのドキュメントを参照してください。
  * 履歴検索が書き直され、fzf風の新しい対話型モーダルダイアログを使うようになりました。
  * メインのREPLモードで`AbstractChar`を表示する際、ヘルプモードと同様にLaTeX入力情報も表示されるようになりました（[#58181](https://github.com/JuliaLang/julia/issues/58181)）。
  * スタックトレース内で、繰り返し現れるフレームや循環を括弧で囲み、一貫して扱うことで、表示が改善されました（[#55841](https://github.com/JuliaLang/julia/issues/55841)）。
  * 言語ではすでにサポートされていた上付き文字U+107A5 𐞥（MODIFIER LETTER SMALL Q）を、REPLで`\^q`として入力できるようになりました（[#59544](https://github.com/JuliaLang/julia/issues/59544)）。

#### Test

  * `Test`が環境変数`JULIA_TEST_VERBOSE`に対応しました。`true`に設定すると、テストセットの開始・終了時にタイミング情報付きの詳細メッセージを表示し、`DefaultTestSet`で詳細な階層型テストサマリーを表示するためのデフォルト`verbose=true`を設定します（[#59295](https://github.com/JuliaLang/julia/issues/59295)）。
  * `@test`マクロを使ったテストの失敗時に、すべての関数呼び出しについて評価済みの引数が表示されるようになりました（[#57825](https://github.com/JuliaLang/julia/issues/57825)、[#57839](https://github.com/JuliaLang/julia/issues/57839)）。
  * 透過的なテストセット（`@testset let`）で、テストがエラーになった際にコンテキストが表示されるようになりました（[#58727](https://github.com/JuliaLang/julia/issues/58727)）。
  * `@test_throws`で、例外の型とメッセージパターンの両方を1回の呼び出しで検証する3引数形式`@test_throws ExceptionType pattern expr`が使えるようになりました（[#59117](https://github.com/JuliaLang/julia/issues/59117)）。
  * テストセットのスタックが、タスクローカルストレージではなく`ScopedValue`を使うように変更されました（[#53462](https://github.com/JuliaLang/julia/issues/53462)）。

#### InteractiveUtils

  * `@code_typed`、`@which`、`@edit`などのイントロスペクションユーティリティで、値の代わりに型注釈を指定できるようになりました。`f(1, ::Float64, 3)`や`sum(::Vector{T}; init = ::T) where {T<:Real}`のような形式も認識されます。型注釈から必要な情報が得られる場合、`f(val::Int; kw::Float64)`のような型注釈付き変数は評価されません。そのため、スタックトレースに現れるシグネチャと互換性があります（[#57909](https://github.com/JuliaLang/julia/issues/57909)、[#58222](https://github.com/JuliaLang/julia/issues/58222)）。
  * `@code_lowered`や`@code_typed`などのコードイントロスペクションマクロで、ブロードキャスト式が大幅にサポート強化されました。`x .+= f(y)`の形式のブロードキャスト代入にも対応しています（[#58349](https://github.com/JuliaLang/julia/issues/58349)）。

#### Dates

  * 週単位のカレンダー向けに、`isoweekdate`、`isoyear`、`weeksinyear`が実装され、エクスポートされるようになりました。[ISO week date](https://en.wikipedia.org/wiki/ISO_week_date)に準拠しています（[#48507](https://github.com/JuliaLang/julia/issues/48507)）。

## External dependencies

  * 7-Zipがp7zip v17.06から上流版7-Zip v25.01に更新されました。Windowsでは、7z.exe/7z.dllの完全なバンドルがスタンドアロンの7za.exeに置き換えられました。対応形式は少なくなりますが、プラットフォーム間の動作が統一されます（[#60025](https://github.com/JuliaLang/julia/issues/60025)）。

## Deprecated or removed

  * メソッド`merge(combine::Callable, d::AbstractDict...)`は非推奨となり、代わりに`mergewith`を使うようになりました（[#59775](https://github.com/JuliaLang/julia/issues/59775)）。
