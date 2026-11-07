# Code changes

## Contributing to core functionality or base libraries

*Julia にコードを提供することにより、そのコードを [MIT License](https://github.com/JuliaLang/julia/tree/master/LICENSE.md) の下で公開することに同意したものとみなされます。*

Julia コミュニティでは、問題、機能追加の要望、プルリクエスト（PR）の追跡と議論に [GitHub issues](https://github.com/JuliaLang/julia/issues) を使用しています。

Issue とプルリクエストには、一覧から内容を把握できるよう、説明的なタイトルを付けてください。たとえば、`Add {feature}` と `Fix {bug}` は適切ですが、`Fix #12345. Corrects the bug.` は適切ではありません。

未完成の機能についても、コードレビューを受けるためにプルリクエストを作成できます。その場合は、ドラフト PR として作成し、作業中であることを示す「WIP:」または、作業が完了してマージ可能であることを示す「RFC:」をタイトルの先頭に付けるのが慣例です。これにより、作業中の変更が誤ってマージされるのを防げます。

注: ここでの説明は、ベースライブラリの機能追加や改善を対象としています。作業を始める前に、提案する変更や追加について [Julia Discourse forum](https://discourse.julialang.org) または GitHub の Issue で相談するとよいでしょう。提案する変更は、コア言語ではなくパッケージに属する可能性があります。また、ベースの変更は多くのものを壊す可能性があることにも留意してください。さらに、Julia のビルドには時間がかかるため、通常はコードを単独のファイルで開発して動作を確認してから、ベースライブラリに移すほうが効率的です。

Julia のベースライブラリにコードを追加するには、次の手順に従ってください（これは「基本的な」方法です。より効率的な方法については次のセクションを参照してください）。

1. `base/` ディレクトリ内の適切なファイルを編集するか、必要に応じて新しいファイルを追加します。機能のテストを作成し、`test/` ディレクトリ内のファイルに追加してください。C または Scheme のコードを編集する場合、通常は `src/` またはそのサブディレクトリにあります。ただし、Julia の REPL 初期化に関する一部の処理は `cli/` にあります。
2. 新しいファイルを追加した場合は、Julia のシステムイメージに組み込むため、`sysimg.jl` に追加します。
3. 必要なエクスポートシンボルを `exports.jl` に追加します。
4. テストを `test/Makefile` と `test/choosetests.jl` に含めます。

通常どおりビルドし、`make clean testall` を実行して変更をテストしてください。変更に Makefile や外部依存関係が含まれる場合は、`git clean -fdx` または同等の方法を使い、クリーンなツリーから Julia をビルドできることを確認してください（注意: このコマンドは、Git に登録されていないファイルをすべて削除します）。

### Running specific tests

特定のテストを実行するための `make` ターゲットもあります。

```
make test-bitarray
```

`runtests.jl` スクリプトを使って、たとえば `test/bitarray.jl` や `test/math.jl` を実行することもできます。

```
./usr/bin/julia test/runtests.jl bitarray math
```

### Modifying base more efficiently with Revise.jl

[Revise](https://github.com/timholy/Revise.jl) は、ソースファイルの変更を追跡し、実行中の Julia セッション内の関数定義を自動的に更新するパッケージです。これを使えば、変更をテストするたびに再ビルドすることなく、Base に大幅な変更を加えられます。

標準的な手順は次のとおりです。

1. 型またはマクロを変更する場合は、まず変更を加え、`make` を使って Julia をビルドします（`Revise` は型定義やマクロの変更に対応できないため、この手順が必要です）。Julia のビルドに必要な場合を除き、新しい型に基づく機能まで追加する必要はありません。型定義だけで十分です。
2. Julia の REPL セッションを開始し、次のコマンドを実行します。

```julia
using Revise    # if you aren't launching it in your `.julia/config/startup.jl`
Revise.track(Base)
```

3. `base/` 内のファイルを編集して保存し、機能をテストします。

Julia セッションを再起動する必要がある場合は、上記の手順 2 から始めてください。`Revise.track(Base)` は、Julia の前回のビルド以降の変更を検出し、自動的に反映します。Revise が扱えないコード変更を行った場合にのみ、Julia を再ビルドする必要があります。

また、各 [`test-*` target](https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md#running-specific-tests) に対応する `test-revise-*` ターゲットも用意されています。これらは、対応するテストを実行する前に Revise を使って Base の変更を現在のシステムイメージに読み込みます。テストは必ずしも runtest ハーネスの外で実行できるように作られているわけではないため、コマンドラインから手軽に実行する方法として便利です。

## Contributing to the standard library

標準ライブラリ（stdlib）のパッケージは Julia のシステムイメージに組み込まれています。通常のテスト手順で stdlib パッケージをテストすると、開発中のバージョンではなく、システムイメージ内のバージョンが優先されます。stdlib パッケージをテストするには、次の手順に従ってください。

1. stdlib パッケージ内の `Project.toml` の UUID フィールドを編集します。
2. 開発中の stdlib のディレクトリに移動します。
3. `julia --project=.` を指定して julia を起動します。
4. Pkg モードで `pkg> test` を実行すると、パッケージをテストできます。

UUID を変更すると、パッケージマネージャーはその stdlib パッケージをシステムイメージ内のものとは別のパッケージとして扱うため、システムイメージ内のバージョンが優先されなくなります。

プルリクエストを作成する前に、UUID の値を必ず元に戻してください。

### News-worthy changes

新機能やその他の大きな変更を加えた場合は、`NEWS.md` に簡潔な概要を追加してください。ニュース項目では、プルリクエスト（PR）を `([#pr])` の形式で括弧内に参照してください。PR 番号を追加するには、まず PR を作成し、その後、PR 番号を記載するよう `NEWS.md` を更新するコミットを追加でプッシュします。相互参照リンクを更新するため、julia ディレクトリから `./julia doc/NEWS-update.jl` を定期的に実行しています。ただし、コミットの競合を避けるため、通常の PR では実行しないでください。

### Annotations for new features, deprecations and behavior changes

API の追加や非推奨化、および軽微な動作変更は、マイナーバージョンのリリースで行えます。公開 API の一部であるドキュメント化済みの機能については、マニュアルまたは docstring に互換性に関する注記を追加してください。動作が変更された Julia のマイナーバージョンと、変更内容の簡潔な説明を記載します。

現時点では、将来、注記をプログラムから検索できるよう、必ず次の `compat` admonition を使ってください。

`!!! compat "Julia 1.X"       This method was added in Julia 1.X.`
