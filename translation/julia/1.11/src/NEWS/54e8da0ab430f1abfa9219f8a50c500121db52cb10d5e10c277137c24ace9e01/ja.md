```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/NEWS.md"
```

# Julia v1.11 Release Notes

## New language features

  * 新しい `Memory` タイプは、`Array` の代替として低レベルのコンテナを提供します。`Memory` はオーバーヘッドが少なく、コンストラクタが高速であるため、`Array` のすべての機能（例：多次元）を必要としない状況に適しています。`Array` タイプのほとんどは、現在 `Memory` の上に Julia で実装されており、いくつかの関数（例：`push!`）の大幅な速度向上や、より保守可能なコードにつながっています（[#51319](https://github.com/JuliaLang/julia/issues/51319)）。
  * `public` is a new keyword. Symbols marked with `public` are considered public API. Symbols marked with `export` are now also treated as public API. The difference between `public` and `export` is that `public` names do not become available when `using` a package/module ([#50105](https://github.com/JuliaLang/julia/issues/50105)).
  * `ScopedValue`は、タスク間での継承を伴う動的スコープを実装しています（[#50958](https://github.com/JuliaLang/julia/issues/50958)）。
  * `Manifest.toml` ファイルは、指定された Julia バージョンによって優先的に選択されるように、`Manifest-v{major}.{minor}.toml` 形式にリネームできるようになりました。つまり、同じフォルダー内で `Manifest-v1.11.toml` は v1.11 に使用され、`Manifest.toml` は他のすべての Julia バージョンによって使用されます。これにより、複数の Julia バージョンの環境を同時に管理することが容易になります ([#43845](https://github.com/JuliaLang/julia/issues/43845))。
  * Unicode 15.1 ([#51799](https://github.com/JuliaLang/julia/issues/51799)）のサポート。

## Language changes

  * プリコンパイル中に、`atexit` フックは出力ファイルを保存する前に実行されるようになりました。これにより、ユーザーはプログラムが終了を開始したときに、バックグラウンドの状態（`Timer` のクローズやハートビートタスクへの切断通知の送信など）を安全に解消し、他のリソースをクリーンアップすることができます。
  * コードカバレッジとmallocトラッキングは、パッケージのプリコンパイル段階ではもはや生成されません。さらに、これらのモードでは、トラッキングされていないパッケージに対してpkgimageキャッシュが使用されるようになりました。これは、カバレッジテスト（`julia-actions/julia-runtest`のデフォルト）が、テストされているパッケージ以外のすべてのパッケージに対してpkgimageキャッシュをデフォルトで使用することを意味し、テストの実行が速くなる可能性があります（[#52123](https://github.com/JuliaLang/julia/issues/52123)）。
  * `JULIA_DEPOT_PATH`にパスを指定すると、空の文字列が展開されてデフォルトのユーザーデポ（[#51448](https://github.com/JuliaLang/julia/issues/51448)）が省略されるようになりました。
  * プリコンパイルキャッシュファイルは現在再配置可能であり、その有効性は`mtime`の代わりにソースファイルのコンテンツハッシュを通じて検証されます（[#49866](https://github.com/JuliaLang/julia/issues/49866)）。
  * 拡張機能は、依存する拡張機能のすべてのトリガーを含むトリガー（+ もう1つのトリガー）を持つ場合に、他の拡張機能に依存できるようになりました。この要件を満たさない拡張機能間の依存関係は、拡張サイクルを防ぐために、事前コンパイル中に `Base.get_extension` の使用がブロックされます [#55557](https://github.com/JuliaLang/julia/issues/55557)。

## Compiler/Runtime improvements

  * 更新されたGCヒューリスティックは、個々のオブジェクトではなく、割り当てられたページをカウントするようになりました（[#50144](https://github.com/JuliaLang/julia/issues/50144)）。
  * `Base.@assume_effects` のコードブロックへの注釈付けのサポートを追加しました ([#52400](https://github.com/JuliaLang/julia/issues/52400))。

## Command-line option changes

  * The entry point for Julia has been standardized to `Main.main(args)`. This must be explicitly opted into using the `@main` macro (see the docstring for further details). When opted-in, and `julia` is invoked to run a script or expression (i.e. using `julia script.jl` or `julia -e expr`), `julia` will subsequently run the `Main.main` function automatically. This is intended to unify script and compilation workflows, where code loading may happen in the compiler and execution of `Main.main` may happen in the resulting executable. For interactive use, there is no semantic difference between defining a `main` function and executing the code directly at the end of the script ([#50974](https://github.com/JuliaLang/julia/issues/50974)).
  * `--compiled-modules` および `--pkgimages` フラグは、`existing` に設定できるようになりました。これにより、Julia は既存のキャッシュファイルを読み込むことを考慮しますが、新しいファイルを作成することはありません（[#50586](https://github.com/JuliaLang/julia/issues/50586)、[#52573](https://github.com/JuliaLang/julia/issues/52573)）。
  * `--project` 引数は、渡されたスクリプトファイルに対して相対的な Project.toml を持つディレクトリへのパスを指定するために `@script` を受け入れるようになりました。`--project=@script/foo` は `foo` サブディレクトリを指します。パスが指定されていない場合（つまり、`--project=@script` の場合）、（`--project=@.` のように）ディレクトリとその親ディレクトリが Project.toml を探されます（[#50864](https://github.com/JuliaLang/julia/issues/50864) と [#53352](https://github.com/JuliaLang/julia/issues/53352)）。

## Multi-threading changes

  * `Threads.@threads` は、非均一なワークロード向けに設計された `:greedy` スケジューラをサポートするようになりました。([#52096](https://github.com/JuliaLang/julia/issues/52096))
  * 新しい公開されていない構造体 `Base.Lockable{T, L<:AbstractLock}` は、リソースとそのロックを一緒に束ねるのを簡単にします ([#52898](https://github.com/JuliaLang/julia/issues/52898))。

## Build system changes

  * 新しい `Makefile` があり、プロファイルガイドとリンク時最適化（PGOおよびLTO）戦略を使用してJuliaとLLVMをビルドします。詳細は `contrib/pgo-lto/Makefile` を参照してください（[#45641](https://github.com/JuliaLang/julia/issues/45641)）。

## New library functions

  * テキストに関する「注釈」(`Pair{Symbol, Any}`エントリ、例：`:lang => "en"`または`:face => :magenta`)のアイデアに基づく3つの新しいタイプ。これらの注釈は、可能な限り操作（例：`*`による文字列の連結）を通じて保持されます。

      * `AnnotatedString` は新しい `AbstractString` 型です。これは基になる文字列をラップし、文字列の領域に注釈を付けることを可能にします。この型は、新しい `StyledStrings` 標準ライブラリでスタイリング情報を保持するために広く使用されています。
      * `AnnotatedChar`は新しい`AbstractChar`タイプです。別のcharをラップし、それに適用される注釈のリストを保持します。
      * `AnnotatedIOBuffer` は新しい `IO` タイプで、`IOBuffer` を模倣していますが、注釈付きコンテンツのための特化した `read` / `write` メソッドを持っています。これは一種の「文字列ビルダー」として考えることもでき、注釈付きコンテンツと注釈なしコンテンツの間の接着剤としても機能します。
  * `in!(x, s::AbstractSet)` は、`x` が `s` に含まれているかどうかを返し、含まれていない場合は `x` を `s` に挿入します（[#45156](https://github.com/JuliaLang/julia/issues/45156)、[#51636](https://github.com/JuliaLang/julia/issues/51636)）。
  * 新しい `Libc.mkfifo` 関数は、Unix プラットフォーム上の `mkfifo` C 関数をラップしています ([#34587](https://github.com/JuliaLang/julia/issues/34587))。
  * `logrange(start, stop; length)` makes a range of constant ratio, instead of constant step ([#39071](https://github.com/JuliaLang/julia/issues/39071))
  * `copyuntil(out, io, delim)` と `copyline(out, io)` は、`out::IO` ストリームにデータをコピーします ([#48273](https://github.com/JuliaLang/julia/issues/48273))。
  * `eachrsplit(string, pattern)` は、右から左に分割された部分文字列を反復処理します（[#51646](https://github.com/JuliaLang/julia/issues/51646)）。
  * `Sys.username()` は現在のユーザーのユーザー名を返すために使用できます（[#51897](https://github.com/JuliaLang/julia/issues/51897)）。
  * `Sys.isreadable(), Sys.iswritable()` は、現在のユーザーがそれぞれ読み取りおよび書き込みを許可するアクセス権を持っているかどうかを確認するために使用できます。 ([#53320](https://github.com/JuliaLang/julia/issues/53320))
  * `GC.logging_enabled()` は、`GC.enable_logging` を介して GC ロギングが有効になっているかどうかをテストするために使用できます ([#51647](https://github.com/JuliaLang/julia/issues/51647))。
  * `IdSet` は現在 Base からエクスポートされており、公開と見なされています ([#53262](https://github.com/JuliaLang/julia/issues/53262))。
  * `@time` は、`ReentrantLock` が待機しなければならなかったロックの競合のカウントを報告し、さらにそのカウントを返す新しいマクロ `@lock_conflicts` が追加されました（[#52883](https://github.com/JuliaLang/julia/issues/52883)）。
  * The new macro `Base.Cartesian.@ncallkw` is analogous to `Base.Cartesian.@ncall`, but allows adding keyword arguments to the function call ([#51501](https://github.com/JuliaLang/julia/issues/51501)).
  * 新しい関数 `Docs.hasdoc(module, symbol)` は、名前にドキュメンテーション文字列があるかどうかを示します ([#52139](https://github.com/JuliaLang/julia/issues/52139))。
  * New function `Docs.undocumented_names(module)` returns a module's undocumented public names ([#52413](https://github.com/JuliaLang/julia/issues/52413)).

## New library features

  * `invmod(n, T)` は、`T` が定義する整数環における `n` の剰余逆数を計算します ([#52180](https://github.com/JuliaLang/julia/issues/52180))。
  * `invmod(n)` is an abbreviation for `invmod(n, typeof(n))` for native integer types ([#52180](https://github.com/JuliaLang/julia/issues/52180)).
  * `replace(string, pattern...)` は、出力を文字列として返すのではなく、ストリームに書き込むためのオプションの `IO` 引数をサポートするようになりました ([#48625](https://github.com/JuliaLang/julia/issues/48625))。
  * New methods `allequal(f, itr)` and `allunique(f, itr)` taking a predicate function ([#47679](https://github.com/JuliaLang/julia/issues/47679)).
  * `sizehint!(s, n)` は、縮小を無効にするオプションの `shrink` 引数をサポートするようになりました ([#51929](https://github.com/JuliaLang/julia/issues/51929))。
  * Passing an `IOBuffer` as a stdout argument for `Process` spawn now works as expected, synchronized with `wait` or `success`, so a `Base.BufferStream` is no longer required there for correctness to avoid data races ([#52461](https://github.com/JuliaLang/julia/issues/52461)).
  * プロセスが終了した後、`closewrite`は渡されたストリームに対して自動的に呼び出されなくなります。代わりにプロセスに対して`wait`を呼び出して、コンテンツが完全に書き込まれることを確認し、その後手動で`closewrite`を呼び出してデータ競合を避けるか、すべてを自動的に処理するために`open`のコールバック形式を使用してください（[#52461](https://github.com/JuliaLang/julia/issues/52461)）。
  * `@timed` は、現在、経過したコンパイルおよび再コンパイル時間も返します ([#52889](https://github.com/JuliaLang/julia/issues/52889))。
  * `filter` は現在 `NamedTuple` に対しても作用することができます ([#50795](https://github.com/JuliaLang/julia/issues/50795))。
  * `Iterators.cycle(iter, n)` runs over `iter` a fixed number of times, instead of forever ([#47354](https://github.com/JuliaLang/julia/issues/47354)).
  * `zero(::AbstractArray)` now applies recursively, so `zero([[1,2],[3,4,5]])` now produces the additive identity `[[0,0],[0,0,0]]` rather than erroring ([#38064](https://github.com/JuliaLang/julia/issues/38064)).
  * `include_dependency(path; track_content=true)` は、プレコンパイルキャッシュの再配置可能性を復元するために、`mtime` の使用からプレコンパイル依存関係のハッシュへの切り替えを可能にします ([#51798](https://github.com/JuliaLang/julia/issues/51798))。

## Standard library changes

  * フォールバックメソッド `write(::IO, ::AbstractArray)` は、各要素に対して再帰的に `write` を呼び出していましたが、現在は各値のメモリ内表現を書き込むようになりました。例えば、`write(io, 'a':'b')` は、各文字のUTF-8表現を書くのではなく、各文字に対して4バイトを書き込みます。この新しいフォーマットは `Array` で使用されるものと互換性があり、`read!` を使用してデータを取り戻すことが可能です（[#42593](https://github.com/JuliaLang/julia/issues/42593)）。
  * 状態を持つイテレータに対して `length` を一般的に一貫した方法で定義することは不可能です。`Stateful` イテレータに対する静かに不正確な結果の可能性は、`length(::Stateful)` メソッドを削除することで対処されます。`Stateful` の最後の型パラメータも削除されました。問題: ([#47790](https://github.com/JuliaLang/julia/issues/47790))、PR: ([#51747](https://github.com/JuliaLang/julia/issues/51747))。

#### Package Manager

  * 現在、Project.tomlの`[sources]`セクションでパッケージの「ソース」を指定することが可能です。これを使用して、登録されていない通常の依存関係やテスト依存関係を追加できます。
  * Pkgは現在、`[compat]`の制約に従い、実行中のJuliaバイナリのバージョンが`Project.toml`の制約と互換性がない場合にエラーを発生させます。Pkgは常にレジストリパッケージでこの互換性を遵守してきました。この変更は主にローカルパッケージに影響を与えます。
  * `pkg> add` と `Pkg.add` は、アクティブな環境がパッケージ（`name` と `uuid` エントリを持つ）である場合、新しい直接依存関係のための互換性エントリを追加します。
  * 依存関係は、`pkg> add --weak/extra Foo` または `Pkg.add("Foo", target=:weakdeps/:extras)` の形式を使用して、直接弱依存関係または追加として追加できるようになりました。

#### StyledStrings

  * 新しいスタンダードライブラリが、より包括的で構造的な方法でスタイリングを扱うために登場しました（[#49586](https://github.com/JuliaLang/julia/issues/49586)）。
  * 新しい `Faces` 構造体は、テキストスタイリング情報（フォント、色、装飾など）を格納するコンテナとして機能し、便利で拡張可能（`addface!` を介して）かつカスタマイズ可能（ユーザーの `Faces.toml` と `loadfaces!` を使用して）なスタイル付きコンテンツへのアプローチを提供します ([#49586](https://github.com/JuliaLang/julia/issues/49586))。
  * 新しい `@styled_str` 文字列マクロは、さまざまなフォントやその他の属性を適用した `AnnotatedString` を作成する便利な方法を提供します ([#49586](https://github.com/JuliaLang/julia/issues/49586))。

#### Libdl

  * 新しい `LazyLibrary` タイプが `Libdl` からエクスポートされ、主に JLL 内で使用されるチェーンされた遅延ライブラリのロードを構築するために使用されます ([#50074](https://github.com/JuliaLang/julia/issues/50074))。

#### LinearAlgebra

  * `cbrt(::AbstractMatrix{<:Real})` は現在定義されており、実数行列の実数値行列立方根を返します ([#50661](https://github.com/JuliaLang/julia/issues/50661))。
  * `eigvals/eigen(A, bunchkaufman(B))` と `eigvals/eigen(A, lu(B))` は、それぞれ `B` のバンチカウフマン (LDL) 分解と LU 分解を利用して、`A` と `B` の一般化固有値（`eigen` および固有ベクトル）を効率的に計算します。注意: 第二引数は `bunchkaufman` または `lu` の出力です（[#50471](https://github.com/JuliaLang/julia/issues/50471)）。
  * `eigvals/eigen(::Hermitian{<:Tridiagonal})` のための専門的なディスパッチがあり、これは実対称トリディアゴナル行列を作成するための類似変換を行い、LAPACKルーチンを使用してそれを解決します（[#49546](https://github.com/JuliaLang/julia/issues/49546)）。
  * 構造化行列は、親の軸（`Symmetric`/`Hermitian`/`AbstractTriangular`/`UpperHessenberg`の場合）または主対角線の軸（バンド行列の場合）を保持します（[#52480](https://github.com/JuliaLang/julia/issues/52480)）。
  * `bunchkaufman` と `bunchkaufman!` は、任意の `AbstractFloat`、`Rational` およびそれらの複素数バリアントで動作するようになりました。`bunchkaufman` は、内部的に `Rational{BigInt}` への変換を行うことで `Integer` 型をサポートするようになりました。実対称行列またはエルミート行列の `BunchKaufman` 因子分解オブジェクトによって与えられる対角因子の慣性を計算する新しい関数 `inertia` が追加されました。複素対称行列の場合、`inertia` は対角因子のゼロ固有値の数のみを計算します（[#51487](https://github.com/JuliaLang/julia/issues/51487)）。
  * Packages that specialize matrix-matrix `mul!` with a method signature of the form `mul!(::AbstractMatrix, ::MyMatrix, ::AbstractMatrix, ::Number, ::Number)` no longer encounter method ambiguities when interacting with `LinearAlgebra`. Previously, ambiguities used to arise when multiplying a `MyMatrix` with a structured matrix type provided by LinearAlgebra, such as `AbstractTriangular`, which used to necessitate additional methods to resolve such ambiguities. Similar sources of ambiguities have also been removed for matrix-vector `mul!` operations ([#52837](https://github.com/JuliaLang/julia/issues/52837)).
  * `lu` and `issuccess(::LU)` now accept an `allowsingular` keyword argument. When set to `true`, a valid factorization with rank-deficient U factor will be treated as success instead of throwing an error. Such factorizations are now shown by printing the factors together with a "rank-deficient" note rather than printing a "Failed Factorization" message ([#52957](https://github.com/JuliaLang/julia/issues/52957)).

#### Random

  * `rand` は `Tuple` 型に対するサンプリングをサポートするようになりました（[#35856](https://github.com/JuliaLang/julia/issues/35856)、[#50251](https://github.com/JuliaLang/julia/issues/50251)）。
  * `rand` は現在、`Pair` 型に対するサンプリングをサポートしています ([#28705](https://github.com/JuliaLang/julia/issues/28705))。
  * `Random`によって提供されるRNGをシードする際に、負の整数シードが使用できるようになりました（[#51416](https://github.com/JuliaLang/julia/issues/51416)）。
  * `Random`のシード可能な乱数生成器は、文字列でシードを設定できるようになりました。例えば、`seed!(rng, "a random seed")`のように使用します（[#51527](https://github.com/JuliaLang/julia/issues/51527)）。

#### REPL

  * タブ補完のヒントは、REPLで入力中に薄いテキストで表示されるようになりました。無効にするには、`Base.active_repl.options.hint_tab_completes = false`を対話的に設定するか、startup.jlに記述してください：

    ```
    if VERSION >= v"1.11.0-0"
      atreplinit() do repl
          repl.options.hint_tab_completes = false
      end
    end
    ```

    ([#51229](https://github.com/JuliaLang/julia/issues/51229)).
  * Meta-Mの空のプロンプトでは、前の非メインコンテキストモジュールとメインの間でコンテキストモジュールを切り替えることができるため、簡単に行き来できます（[#51616](https://github.com/JuliaLang/julia/issues/51616)、[#52670](https://github.com/JuliaLang/julia/issues/52670)）。

#### Dates

未文書の関数 `adjust` はもはやエクスポートされていませんが、現在は文書化されています（[#53092](https://github.com/JuliaLang/julia/issues/53092)）。

#### Statistics

  * 統計は現在、アップグレード可能な標準ライブラリです（[#46501](https://github.com/JuliaLang/julia/issues/46501)）。

#### Distributed

  * `pmap` は現在、`CachingPool` をデフォルトで使用します ([#33892](https://github.com/JuliaLang/julia/issues/33892))。

## Deprecated or removed

  * `Base.map`、`Iterators.map`、および `foreach` は、単一引数メソッドを失いました（[#52631](https://github.com/JuliaLang/julia/issues/52631)）。

## External dependencies

  * libuvライブラリは、v1.44.2からv1.48.0に更新されました（[#49937](https://github.com/JuliaLang/julia/issues/49937)）。
  * `tput`はもはや端末の機能を確認するために呼び出されておらず、純粋なJuliaのterminfoパーサーに置き換えられました（[#50797](https://github.com/JuliaLang/julia/issues/50797)）。
  * ターミナル情報データベース `terminfo` はデフォルトでベンダー化されており、システムに `terminfo` がない場合でもより良い REPL ユーザーエクスペリエンスを提供します。Julia は、Makefile オプション `WITH_TERMINFO=0` を使用してデータベースをベンダー化せずにビルドすることができます。 ([#55411](https://github.com/JuliaLang/julia/issues/55411))

## Tooling Improvements

  * CIは現在、すべてのPRに対して限定的な自動タイプミス検出を行っています。タイプミスCIチェックが失敗しているPRをマージすると、報告されたタイプミスは、同じファイルを編集するPRの将来のCI実行で自動的に無視されます（[#51704](https://github.com/JuliaLang/julia/issues/51704)）。
