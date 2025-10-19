```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/NEWS.md"
```

# Julia v1.12 Release Notes

## New language features

  * 新しい実験的オプション `--trim` は、エントリポイントから到達可能であることが証明されていないコードを削除することによって、より小さなバイナリを作成します。エントリポイントは `Base.Experimental.entrypoint` を使用してマークできます（[#55047](https://github.com/JuliaLang/julia/issues/55047)）。このオプションで全てのコードが動作するとは限らず、実験的なため問題が発生する可能性があります。
  * 定数の再定義は現在明確に定義されており、世界年齢セマンティクスに従っています ([#57253](https://github.com/JuliaLang/julia/issues/57253))。タイプの再定義など、追加の再定義が現在許可されています。詳細は [the new manual chapter on world age](https://docs.julialang.org/en/v1.13-dev/manual/worldage/) を参照してください。
  * A new keyword argument `usings::Bool` has been added to `names`, returning all names visible via `using` ([#54609](https://github.com/JuliaLang/julia/issues/54609)).
  * The `@atomic` macro family now supports reference assignment syntax, e.g. `@atomic :monotonic v[3] += 4`, which modifies `v[3]` atomically with monotonic ordering semantics ([#54707](https://github.com/JuliaLang/julia/issues/54707)). The supported syntax allows

      * 原子取得（`x = @atomic v[3]`）、
      * atomic set (`@atomic v[3] = 4`)、
      * atomic modify (`@atomic v[3] += 2`)、
      * atomic set once (`@atomiconce v[3] = 2`)、
      * 原子スワップ (`x = @atomicswap v[3] = 2`)、および
      * 原子置換 (`x = @atomicreplace v[3] 2=>5`).
  * 新しいオプション `--task-metrics=yes` は、タスクごとのタイミング情報の収集を有効にします。これは、`Base.Experimental.task_metrics(::Bool)` を使用してランタイムで有効/無効にすることもできます ([#56320](https://github.com/JuliaLang/julia/issues/56320))。利用可能なメトリックは次のとおりです：

      * 実際のタスクの実行時間（`Base.Experimental.task_running_time_ns`）、および
      * タスクの壁時間（`Base.Experimental.task_wall_time_ns`）。
  * Unicode 16 ([#56925](https://github.com/JuliaLang/julia/issues/56925)）のサポート。
  * `Threads.@spawn` は、呼び出し元と同じスレッドプールを指定するための `:samepool` 引数を受け取るようになりました。 `Threads.@spawn :samepool foo()` は、 `Threads.@spawn Threads.threadpool() foo()` の短縮形です。 ([#57109](https://github.com/JuliaLang/julia/issues/57109))
  * `@ccall` マクロは、`gc_safe` 引数を受け取ることができるようになりました。これが true に設定されている場合、ランタイムは `ccall` と同時にガーベジコレクションを実行することができます ([#49933](https://github.com/JuliaLang/julia/issues/49933))。

## Language changes

  * メソッドが完全に同等のもので置き換えられると、古いメソッドは削除されません。代わりに、新しいメソッドが優先され、古いメソッドよりも特異的になります。したがって、新しいメソッドが後で削除されると、古いメソッドが再び動作を開始します。これは、SparseArrays、Pluto、Mockingなどのモッキングフレームワークで便利です。これらは古いメソッドを明示的に復元する必要がありません。この時、推論とコンパイルはこの状況で繰り返される必要がありますが、最終的には古い結果を再利用できるようになるかもしれません（[#53415](https://github.com/JuliaLang/julia/issues/53415)）。
  * マクロ展開は、もはやマクロから返される `Expr(:toplevel)` 表現に対して早期に再帰しません。代わりに、`:toplevel` 表現のマクロ展開は評価時まで遅延されます。これにより、特定の `:toplevel` 表現内の後の表現が、同じ `:toplevel` 表現内で以前に定義されたマクロを利用できるようになります ([#53515](https://github.com/JuliaLang/julia/issues/53515))。
  * トリビアルな無限ループ（`while true; end`のような）はもはや未定義の動作ではありません。何かを行う無限ループ（例えば、副作用があるものやスリープするもの）は、以前から未定義の動作ではなく、今もそうではありません（[#52999](https://github.com/JuliaLang/julia/issues/52999)）。
  * バインディングを `public` と `export` の両方としてマークすることは、現在エラーです ([#53664](https://github.com/JuliaLang/julia/issues/53664))。
  * `getfield`中のエラーは、一般的な`ErrorException`の代わりに新しい`FieldError`例外タイプを発生させるようになりました。 ([#54504](https://github.com/JuliaLang/julia/issues/54504))
  * 関数シグネチャの位置におけるマクロはもはや括弧を必要としません。例えば、`function @main(args) ... end` は現在許可されていますが、以前のJuliaバージョンでは `function (@main)(args) ... end` が必要でした。
  * パッケージ名の内部で`using`を呼び出すこと（特にサブモジュールに関連する）は、マニフェストや環境を調べることなく、そのパッケージを明示的に使用します。これは`..Name`の動作と同じです。これは、ユーザーが実際にどのように動作することを期待しているかにより適合しているようです（[#57727](https://github.com/JuliaLang/julia/issues/57727)）。

## Compiler/Runtime improvements

  * 生成されたLLVM IRは、ポインタを整数として渡すのではなく、ポインタ型を使用するようになりました。これにより`llvmcall`に影響があります：インラインLLVM IRは、`i32`や`i64`の代わりに`i8*`または`ptr`を使用するように更新し、不要な`ptrtoint`/`inttoptr`変換を削除する必要があります。互換性のために、整数ポインタを持つIRは引き続きサポートされていますが、非推奨の警告が生成されます（[#53687](https://github.com/JuliaLang/julia/issues/53687)）。

## Command-line option changes

  * `-m/--module` フラグは、引数のセットを持つパッケージ内の `main` 関数を実行するために渡すことができます。この `main` 関数は、エントリーポイントであることを示すために `@main` を使用して宣言する必要があります ([#52103](https://github.com/JuliaLang/julia/issues/52103))。
  * Juliaでのカラーテキストの有効化または無効化は、[`NO_COLOR`](https://no-color.org/)または[`FORCE_COLOR`](https://force-color.org/)環境変数で制御できるようになりました。これらの変数は、Juliaのビルドシステム（[#53742](https://github.com/JuliaLang/julia/issues/53742)、[#56346](https://github.com/JuliaLang/julia/issues/56346)）でも尊重されます。
  * `--project=@temp` は、一時的な環境で Julia を起動します（[#51149](https://github.com/JuliaLang/julia/issues/51149)）。
  * 新しい `--trace-compile-timing` オプションは、`--trace-compile` によって報告された各メソッドのコンパイルにかかった時間をミリ秒単位で報告します ([#54662](https://github.com/JuliaLang/julia/issues/54662))。
  * `--trace-compile` は、再コンパイルされたメソッドを黄色で表示するか、色がサポートされていない場合は末尾にコメントを付けて表示します ([#55763](https://github.com/JuliaLang/julia/issues/55763))。
  * 新しい `--trace-dispatch` オプションが追加され、動的にディスパッチされるメソッドを報告します ([#55848](https://github.com/JuliaLang/julia/issues/55848))。

## Multi-threading changes

  * Juliaは現在、1つのデフォルトの「ワーカー」スレッドに加えて、1つの「インタラクティブ」スレッドをデフォルトとしています。すなわち、`-t1,1`です。これは、デフォルトの構成では、メインタスクとREPL（インタラクティブモードのときに実行される）が両方ともスレッド1で実行され、現在は`interactive`スレッドプール内で実行されることを意味します。libuv IOループもスレッド1で実行され、`Threads.@spawn`によって使用されるワーカースレッドプールの効率的な利用を助けます。特に1つのスレッド（`-t1`/`JULIA_NUM_THREADS=1`）または`0`のインタラクティブスレッドを要求すると、インタラクティブスレッドが無効になります。すなわち、`-t1,0`または`JULIA_NUM_THREADS=1,0`、または`-tauto,0`などです。1つ以上のスレッドを要求すると、インタラクティブスレッドが有効になり、`-t2`は`-t2,1`と同等の設定になります。リマインダーとして、バッファは[should not be managed based on `threadid()`](https://docs.julialang.org/en/v1/manual/multi-threading/#Using-@threads-without-data-races)（[#57087](https://github.com/JuliaLang/julia/issues/57087)）です。
  * New types are defined to handle the pattern of code that must run once per process, called a `OncePerProcess{T}` type, which allows defining a function that should be run exactly once the first time it is called, and then always return the same result value of type `T` every subsequent time afterwards. There are also `OncePerThread{T}` and `OncePerTask{T}` types for similar usage with threads or tasks ([#55793](https://github.com/JuliaLang/julia/issues/55793)).

## Build system changes

  * 新しい `Makefile` が、バイナリ最適化およびレイアウトツール (BOLT) を使用して Julia と LLVM をビルドするために用意されています。`contrib/bolt` と `contrib/pgo-lto-bolt` を参照してください ([#54107](https://github.com/JuliaLang/julia/issues/54107))。

## New library functions

  * `logrange(start, stop; length)` は、定数ステップの代わりに定数比の範囲を作成します。 ([#39071](https://github.com/JuliaLang/julia/issues/39071))
  * The new `isfull(c::Channel)` function can be used to check if `put!(c, some_value)` will block ([#53159](https://github.com/JuliaLang/julia/issues/53159)).
  * `waitany(tasks; throw=false)` と `waitall(tasks; failfast=false, throw=false)` は、複数のタスクを同時に待機します ([#53341](https://github.com/JuliaLang/julia/issues/53341))。
  * `uuid7()` は、バージョン 7 の RFC 9562 準拠の UUID を作成します（[#54834](https://github.com/JuliaLang/julia/issues/54834)）。
  * `insertdims(array; dims)` inserts singleton dimensions into an array –- the inverse operation of `dropdims` ([#45793](https://github.com/JuliaLang/julia/issues/45793)).
  * 新しい `Fix` 型は、単一の引数を修正するために `Fix1/Fix2` を一般化します。([#54653](https://github.com/JuliaLang/julia/issues/54653))
  * `Sys.detectwsl()` は、実行時に Julia が WSL 内で動作しているかどうかをテストします ([#57069](https://github.com/JuliaLang/julia/issues/57069))。

## New library features

  * `escape_string` は追加のキーワード引数 `ascii=true`（すべての非ASCII文字をエスケープするため）と `fullhex=true`（C互換性のために u/U エスケープに対して完全な4/8桁の16進数を要求するため）を取ります（例： [#55099](https://github.com/JuliaLang/julia/issues/55099)）。
  * `tempname` は、ファイル名にサフィックスを含めることを可能にするサフィックス文字列を受け取ることができ、そのサフィックスをユニークチェックに含めます（[#53474](https://github.com/JuliaLang/julia/issues/53474)）。
  * `RegexMatch` オブジェクトは、`NamedTuple` と `Dict` を構築するために使用できるようになりました ([#50988](https://github.com/JuliaLang/julia/issues/50988))。
  * `Lockable` は現在エクスポートされています ([#54595](https://github.com/JuliaLang/julia/issues/54595))。
  * `Base.require_one_based_indexing` と `Base.has_offset_axes` は現在公開されています ([#56196](https://github.com/JuliaLang/julia/issues/56196))。
  * New `ltruncate`, `rtruncate` and `ctruncate` functions for truncating strings to text width, accounting for char widths ([#55351](https://github.com/JuliaLang/julia/issues/55351)).
  * `isless`（およびそれに伴う `cmp`、ソートなど）は、ゼロ次元の `AbstractArray` に対してサポートされるようになりました（[#55772](https://github.com/JuliaLang/julia/issues/55772)）。
  * `invoke` は、型シグネチャの代わりに `Method` を渡すことをサポートするようになりました ([#56692](https://github.com/JuliaLang/julia/issues/56692))。
  * `invoke` は、型の代わりに `CodeInstance` を渡すことをサポートするようになりました。これにより、特定のコンパイラプラグインワークフローが可能になります ([#56660](https://github.com/JuliaLang/julia/issues/56660))。
  * `Timer(f, ...)` は、タイマータスクを作成する際に親タスクのスティッキー状態に一致するようになり、新しい `spawn` キーワード引数によって上書きすることができます。これにより、スティッキーなタスク（すなわち `@async`）がその親をスティッキーにするという問題を回避します ([#56745](https://github.com/JuliaLang/julia/issues/56745))。
  * `Timer` は、読みやすい `timeout` および `interval` プロパティを持ち、より説明的な `show` メソッドを持っています ([#57081](https://github.com/JuliaLang/julia/issues/57081))。
  * `sort` は現在 `NTuple` をサポートしています ([#54494](https://github.com/JuliaLang/julia/issues/54494))。
  * `map!(f, A)` は、`map!(f, A, A)` や `A .= f.(A)` のように、結果を `A` に格納します ([#40632](https://github.com/JuliaLang/julia/issues/40632))。
  * `setprecision` を関数引数（通常は `do` ブロック）で使用することは、現在スレッドセーフです。他の形式は避けるべきであり、型は `ScopedValue` を使用する実装に切り替えるべきです（[#51362](https://github.com/JuliaLang/julia/issues/51362)）。

## Standard library changes

  * `gcdx(0, 0)` は `(0, 0, 0)` を返すようになりました。以前は `(0, 1, 0)` を返していました。([#40989](https://github.com/JuliaLang/julia/issues/40989))
  * `fd` は `Int` の代わりに `RawFD` を返します ([#55080](https://github.com/JuliaLang/julia/issues/55080))。

#### JuliaSyntaxHighlighting

  * 新しい標準ライブラリで、Juliaコードに構文ハイライトを適用するためのもので、`JuliaSyntax`と`StyledStrings`を使用して、構文ハイライトが適用された`AnnotatedString`を作成する`highlight`関数を実装しています（[#51810](https://github.com/JuliaLang/julia/issues/51810)）。

#### LinearAlgebra

  * `rank` は、QR因子分解を介してランク推定を可能にする `QRPivoted` 行列を受け取ることができるようになりました ([#54283](https://github.com/JuliaLang/julia/issues/54283))。
  * Added keyword argument `alg` to `eigen`, `eigen!`, `eigvals` and `eigvals!` for self-adjoint matrix types (i.e., the type union `RealHermSymComplexHerm`) that allows one to switch between different eigendecomposition algorithms ([#49355](https://github.com/JuliaLang/julia/issues/49355)).
  * Added a generic version of the (unblocked) pivoted Cholesky decomposition (callable via `cholesky[!](A, RowMaximum())`) ([#54619](https://github.com/JuliaLang/julia/issues/54619)).
  * デフォルトのBLASスレッド数は、システムで利用可能な論理スレッドの総数を使用するのではなく、プロセスのアフィニティを尊重するようになりました。([#55574](https://github.com/JuliaLang/julia/issues/55574))
  * 新しい関数 `zeroslike` が追加され、行列値のバンド行列のゼロ要素を生成します。カスタム配列タイプは、この関数を特化させて適切な結果を返すことができます ([#55252](https://github.com/JuliaLang/julia/issues/55252))。
  * 行列の乗算 `A * B` は、宛先を生成するために `matprod_dest(A, B, T::Type)` を呼び出します。この関数は現在公開されています ([#55537](https://github.com/JuliaLang/julia/issues/55537))。
  * 関数 `haszero(T::Type)` は、型 `T` に `zero(T)` として定義された一意のゼロ要素が存在するかどうかを確認するために使用されます。これは現在公開されています ([#56223](https://github.com/JuliaLang/julia/issues/56223))。
  * 新しい関数 `diagview` が追加され、`AbstractMatrix` の特定のバンドへのビューを返します ([#56175](https://github.com/JuliaLang/julia/issues/56175))。

#### Profile

  * `Profile.take_heap_snapshot` は新しいキーワード引数 `redact_data::Bool` を受け取り、デフォルトは `true` です。設定されている場合、Julia オブジェクトの内容はヒープスナップショットに出力されません。これは現在、文字列にのみ適用されます（[#55326](https://github.com/JuliaLang/julia/issues/55326)）。
  * `Profile.print()` は、スタックトレースでの表示と同様に、Base/Core/Package モジュールに色を付けるようになりました。また、パスは切り捨てられていても、URI リンクをサポートするターミナルではクリック可能になり、指定されたファイルと行番号に対して `JULIA_EDITOR` に移動できます ([#55335](https://github.com/JuliaLang/julia/issues/55335))。

#### REPL

  * 新しい `usings=true` 機能を使用した `names()` 関数により、REPL の補完は `using` を介して表示される名前を補完できるようになりました ([#54610](https://github.com/JuliaLang/julia/issues/54610))。
  * REPL completions can now complete input lines like `[import|using] Mod: xxx|` e.g. complete `using Base.Experimental: @op` to `using Base.Experimental: @opaque` ([#54719](https://github.com/JuliaLang/julia/issues/54719)).
  * The REPL will now warn if it detects a name is being accessed via a module which does not define it (nor has a submodule which defines it), and for which the name is not public in that module. For example, `map` is defined in Base, and executing `LinearAlgebra.map` in the REPL will now issue a warning the first time it occurs ([#54872](https://github.com/JuliaLang/julia/issues/54872)).
  * REPL入力の結果が印刷されるとき、出力は現在20 KiBに切り捨てられます。これは、`show`、`print`などの手動呼び出しには影響しません。([#53959](https://github.com/JuliaLang/julia/issues/53959))
  * バックスラッシュの補完は、各一致するバックスラッシュショートコードの横にそれぞれのグリフまたは絵文字を表示するようになりました（[#54800](https://github.com/JuliaLang/julia/issues/54800)）。

#### Test

  * 失敗した `DefaultTestSet` は、失敗したテストの乱数生成器 (RNG) を画面に表示するようになり、RNG の状態にのみ依存する確率的な失敗を再現するのに役立ちます。また、`@testset` に `rng` キーワード引数を渡すことで、テストセットにシードを設定することも可能です。

    ```julia
    using Test, Random
    @testset rng=Xoshiro(0x2e026445595ed28e, 0x07bb81ac4c54926d, 0x83d7d70843e8bad6, 0xdbef927d150af80b, 0xdbf91ddf2534f850) begin
        @test rand() == 0.559472630416976
    end
    ```

#### InteractiveUtils

  * 新しいマクロ `@trace_compile` と `@trace_dispatch` が、`--trace-compile=stderr --trace-compile-timing` および `--trace-dispatch=stderr` をそれぞれ有効にして式を実行するために追加されました。 ([#55915](https://github.com/JuliaLang/julia/issues/55915))

## External dependencies

  * ターミナル情報データベース `terminfo` はデフォルトでベンダー化されており、システムに `terminfo` がない場合でもより良い REPL ユーザーエクスペリエンスを提供します。Julia は、Makefile オプション `WITH_TERMINFO=0` を使用してデータベースをベンダー化せずにビルドすることができます ([#55411](https://github.com/JuliaLang/julia/issues/55411))。

## Tooling Improvements

  * ウォールタイムプロファイラーが利用可能になりました。これは、スケジューリングや実行状態に関係なくタスクをキャプチャするサンプリングプロファイラーを必要とするユーザー向けです。このタイプのプロファイラーは、I/O集約型タスクのプロファイリングを可能にし、システム内の重い競合の領域を検出するのに役立ちます ([#55889](https://github.com/JuliaLang/julia/issues/55889))。
