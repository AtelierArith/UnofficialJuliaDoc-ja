# Code changes

## Contributing to core functionality or base libraries

*Juliaへのコードの貢献は、[MIT License](https://github.com/JuliaLang/julia/tree/master/LICENSE.md)のライセンスの下で公開することに同意したものとみなされます。*

Juliaコミュニティでは、問題、機能追加の要望、プルリクエスト（PR）の追跡と議論に[GitHub issues](https://github.com/JuliaLang/julia/issues)を使用しています。

Issueやプルリクエストには、PRやIssueの一覧から内容が分かるよう、説明的なタイトルを付けてください。たとえば、`Add {feature}`や`Fix {bug}`は適切ですが、`Fix #12345. Corrects the bug.`は適切ではありません。

未完成の機能についても、コードレビューを受けるためにプルリクエストを作成できます。その場合は、ドラフトPRとして作成し、作業中であることを示す「WIP:」（Work In Progress）、または作業が完了してマージ可能であることを示す「RFC:」（Request for Comments）をタイトルの先頭に付けるのが慣例です。これにより、作業中の変更が誤ってマージされるのを防げます。

注: ここでの説明は、標準ライブラリの機能を追加・改善する場合を対象としています。作業を始める前に、提案する変更や追加について[Julia Discourse forum](https://discourse.julialang.org)やGitHub Issueで相談するとよいでしょう。提案する変更は、コア言語ではなくパッケージに属する可能性もあります。また、標準ライブラリの変更は多くの機能を壊す可能性があることにも留意してください。さらに、Juliaのビルドには時間がかかるため、通常はまず独立したファイルでコードを開発して動作させてから、標準ライブラリに移すほうが効率的です。

Juliaの標準ライブラリにコードを追加するには、次の手順に従ってください（これは「基本的な」方法です。より効率的な方法については次のセクションを参照してください）。

1. `base/`ディレクトリ内の適切なファイルを編集するか、必要に応じて新しいファイルを追加します。機能のテストを作成し、`test/`ディレクトリ内のファイルに追加してください。CまたはSchemeのコードを編集する場合、通常は`src/`またはそのサブディレクトリにあります。ただし、JuliaのREPL初期化の一部は`cli/`にあります。
2. 新しいファイルを`sysimg.jl`に追加し、Juliaのシステムイメージに組み込まれるようにします。
3. 必要なエクスポートシンボルを`exports.jl`に追加します。
4. テストを`test/Makefile`と`test/choosetests.jl`に含めます。

通常どおりビルドし、`make clean testall`を実行して変更をテストしてください。Makefileや外部依存関係を変更した場合は、`git clean -fdx`などを使い、クリーンなツリーからJuliaをビルドできることを確認してください（注意: このコマンドは、Gitで管理されていないファイルをすべて削除します）。

### Running specific tests

特定のテストを実行するための`make`ターゲットもあります。

```
make test-bitarray
```

`runtests.jl`スクリプトを使うこともできます。たとえば、`test/bitarray.jl`や`test/math.jl`を実行できます。

```
./usr/bin/julia test/runtests.jl bitarray math
```

### Modifying base more efficiently with Revise.jl

[Revise](https://github.com/timholy/Revise.jl)は、ソースファイルの変更を追跡し、実行中のJuliaセッション内の関数定義を自動的に更新するパッケージです。これを使えば、変更をテストするたびに再ビルドしなくても、Baseに大幅な変更を加えられます。

標準的な手順は次のとおりです。

1. 型やマクロを変更する場合は、まず変更を加え、`make`を使ってJuliaをビルドします（`Revise`では型定義やマクロの変更を扱えないためです）。Juliaをビルドするために必要な場合を除き、新しい型に基づく機能まで追加する必要はありません。型定義だけで十分です。
2. JuliaのREPLセッションを開始し、次のコマンドを実行します。

```julia
using Revise    # if you aren't launching it in your `.julia/config/startup.jl`
Revise.track(Base)
```

3. `base/`内のファイルを編集して保存し、機能をテストします。

Juliaセッションを再起動する必要がある場合は、上記の手順2から始めてください。`Revise.track(Base)`は、Juliaの最終ビルド以降の変更を検出し、自動的に反映します。Reviseで扱えないコード変更を行った場合にのみ、Juliaを再ビルドする必要があります。

また、各[`test-*` target](https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md#running-specific-tests)に対応する`test-revise-*`ターゲットも用意されています。これらは、対応するテストを実行する前にReviseを使ってBaseへの変更を現在のシステムイメージに読み込みます。テストは必ずしもruntestハーネスの外で実行できるように作られているわけではないため、コマンドラインから手軽に実行する方法として便利です。

## Contributing to the standard library

標準ライブラリ（stdlib）のパッケージはJuliaのシステムイメージに組み込まれています。通常のテスト手順でstdlibパッケージをテストすると、開発中のバージョンではなく、システムイメージ内のバージョンが使われます。stdlibパッケージをテストするには、次の手順に従ってください。

1. stdlibパッケージ内の`Project.toml`のUUIDフィールドを編集します。
2. 開発中のstdlibのディレクトリに移動します。
3. `julia --project=.`を指定してjuliaを起動します。
4. Pkgモードで`pkg> test`を実行すると、パッケージをテストできます。

UUIDを変更すると、パッケージマネージャーはstdlibパッケージをシステムイメージ内のものとは別のパッケージとして扱うため、システムイメージ内のバージョンが優先されなくなります。

プルリクエストを作成する前に、UUIDの値を必ず元に戻してください。

### News-worthy changes

新機能やその他の大きな変更を加えた場合は、`NEWS.md`に簡潔な概要を追加してください。ニュース項目では、プルリクエスト（PR）を`([#pr])`の形式で括弧内に参照してください。PR番号を追加するには、まずPRを作成し、その後、PR番号を記載するよう`NEWS.md`を更新するコミットを追加でプッシュします。相互参照リンクを更新するため、juliaディレクトリから定期的に`./julia doc/NEWS-update.jl`を実行しています。ただし、コミットの競合を避けるため、通常のPRでは実行しないでください。

### Annotations for new features, deprecations and behavior changes

マイナーバージョンリリースでは、APIの追加や非推奨化、および軽微な動作変更が認められています。公開APIの一部である、ドキュメント化された機能については、マニュアルまたはdocstringに互換性に関する注記を追加してください。動作が変更されたJuliaのマイナーバージョンと、変更内容の簡潔な説明を記載します。

現時点では、将来注記をプログラムから検索できるよう、必ず次の`compat` admonitionを使ってください。

`!!! compat "Julia 1.X"       This method was added in Julia 1.X.`
