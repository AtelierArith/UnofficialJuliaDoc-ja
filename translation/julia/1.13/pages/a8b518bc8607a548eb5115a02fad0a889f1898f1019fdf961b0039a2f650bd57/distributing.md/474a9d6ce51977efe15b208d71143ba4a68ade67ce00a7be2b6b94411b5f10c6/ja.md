# Binary distributions

これらのメモは、さまざまなプラットフォーム向けに配布する Julia のバイナリ配布物をコンパイルしたい方を対象としています。Julia をできるだけ広く普及させ、できるだけ多くのオペレーティングシステムやハードウェア構成で試していただけるのは、私たちにとって大きな喜びです。プラットフォームごとに、移植性があり正常に動作する Julia の配布物を作成するために注意すべき点や手順が異なるため、メモの大部分は OS ごとに分けています。

Julia のコードは [MIT-licensed, with a few exceptions](https://github.com/JuliaLang/julia/blob/master/LICENSE.md) ですが、ここで説明する方法で作成した配布物は GPL ライセンスになります。これは、`SuiteSparse` など、依存ライブラリの一部が GPL ライセンスだからです。将来的には、GPL ではない Julia の配布物も提供したいと考えています。

## Versioning and Git

Makefile は `VERSION` ファイルと、git リポジトリのコミットハッシュおよびタグを使って `base/version_git.jl` を生成します。この情報は、スプラッシュ画面と `versioninfo()` の出力に表示する内容を設定するために使われます。何らかの理由でビルド時に git リポジトリを利用できない場合は、次のコマンドで `base/version_git.jl` ファイルを事前に生成してください。

```
make -C base version_git.jl.phony
```

Julia には多数のビルド依存関係があり、その中には、一般的なパッケージマネージャーにはまだ含まれていないパッチ適用済みのバージョンを使っているものもあります。通常、これらの依存関係はビルド時に自動でダウンロードされます。ただし、インターネットに接続できないコンピューターでも Julia をビルドできるようにするには、次の専用 make ターゲットを使って、ソース一式を含むアーカイブを作成してください。

```
make full-source-dist
```

このターゲットは、必要な依存関係をすべて含む julia-version-commit.tar.gz アーカイブを作成します。

git リポジトリ内でタグ付きリリースをコンパイルする場合、スプラッシュ画面にはブランチ名やコミットハッシュの情報は表示されません。代わりに、最大45文字のリリース説明を表示するには、次の行を使います。この行を設定するには、次の内容を記述した Make.user ファイルを作成してください。

```
override TAGGED_RELEASE_BANNER = "my-package-repository build"
```

## Target Architectures

デフォルトでは、Julia はビルドマシンのネイティブアーキテクチャに合わせてシステムイメージを最適化します。パッケージをビルドする場合、通常これは望ましくありません。対応していない CPU（特に、命令セットに制限のある古い CPU）を搭載したマシンでは、Julia が起動時に失敗するためです。

そのため、`make` の実行時に `MARCH` 変数を渡し、サポート対象とするベースラインのターゲットを設定することを推奨します。これにより、Julia の実行ファイルとライブラリ、およびシステムイメージのターゲット CPU が決まります（システムイメージのターゲットは [`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET) を使って設定することもできます）。x86 CPU で一般的に有用な値は、64ビットビルドでは `x86-64` と `core2`、32ビットビルドでは `pentium4` です。残念ながら、Pentium 4 より古い CPU は現在サポートされていません（[this issue](https://github.com/JuliaLang/julia/issues/7185) を参照）。

LLVM がサポートする CPU ターゲットの一覧は、`llc -mattr=help` を実行すると確認できます。

## Linux

Linux では、`make binary-dist` により、完全に動作する Julia のインストールを含む tarball が作成されます。`.deb` や `.rpm` などの配布パッケージを作成するには、追加の作業が必要です。Debian および Ubuntu 系システム向けの `.deb` パッケージの作成に必要なメタデータの例は、[julia-debian](https://github.com/staticfloat/julia-debian) リポジトリを参照してください。RPM ベースのディストリビューションについては、[Fedora package](https://src.fedoraproject.org/rpms/julia) を参照してください。まだ試してはいませんが、[Alien](https://wiki.debian.org/Alien) を使って、さまざまな Linux ディストリビューション向けの Julia パッケージを生成できる可能性があります。

Julia では、`make` および `make install` の実行時に渡せる `prefix` などの環境変数を使って、標準のインストール先ディレクトリを変更できます。環境変数の一覧は Make.inc を参照してください。`DESTDIR` を使うと、一時ディレクトリへのインストールを強制することもできます。

デフォルトでは、Julia はインストール全体に適用される初期化ファイルとして `$prefix/etc/julia/startup.jl` を読み込みます。このファイルは、ディストリビューションの管理者が独自のパスや初期化コードを設定するために使えます。Linux ディストリビューションのパッケージで `$prefix` が `/usr` に設定されている場合、参照する `/usr/etc` はありません。そのため、Julia のプライベートな `etc` ディレクトリのパスを変更する必要があります。これは、ビルド時に `sysconfdir` make 変数を使って設定できます。ビルド時に `make` に `sysconfdir=/etc` を渡すだけで、Julia は `$prefix/etc/julia/startup.jl` を試す前に `/etc/julia/startup.jl` を確認するようになります。

## OS X

OSX 向けのバイナリ配布物を作成するには、まず Julia をビルドします。次に `contrib/mac/app` に移動し、Julia 本体のビルド時に `make` で使ったものと同じ makevars を指定して、`make` を実行します。これにより、完全に自己完結した Julia.app を格納する `.dmg` ファイルが `contrib/mac/app` ディレクトリに作成されます。

または、`make` に `darwinframework` ターゲットを指定し、`DARWIN_FRAMEWORK=1` を設定すると、Julia をフレームワークとしてビルドできます。たとえば、`make DARWIN_FRAMEWORK=1 darwinframework` のようにします。

## Windows

Windows 向けの Julia 配布物の作成手順は、[build devdocs for Windows](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/windows.md) に記載されています。

## Notes on BLAS and LAPACK

デフォルトでは、Julia は BLAS および LAPACK ライブラリを含む OpenBLAS をビルドします。32ビットアーキテクチャでは、Julia は OpenBLAS が32ビット整数を使うようにビルドします。一方、64ビットアーキテクチャでは、64ビット整数（ILP64）を使うようにビルドします。BLAS および LAPACK の API ルーチンを呼び出すすべての Julia 関数で、正しい幅の整数を使うことが不可欠です。

Linux ディストリビューションで提供される BLAS および LAPACK の多くは、市販の実装も含め、32ビット API を使うライブラリを提供しています。64ビット API が別のライブラリとして提供されている場合も少なくありません。

ベンダー提供または OS 提供のライブラリを使う場合、Julia のビルドでは `make` オプションとして `USE_BLAS64` を利用できます。`make USE_BLAS64=0` を行うと、64ビットアーキテクチャ上でも、すべての整数が32ビット幅である32ビット API を前提として Julia が BLAS および LAPACK を呼び出します。

SuiteSparse など、Julia が使うほかのライブラリも、内部で BLAS および LAPACK を使います。BLAS および LAPACK に依存するすべてのライブラリで、API の整合性を保つ必要があります。Julia のビルドプロセスでは、これらのライブラリがすべて正しくビルドされますが、デフォルト設定を変更してシステム提供のライブラリを使う場合は、この整合性を確保しなければなりません。

また、Linux ディストリビューションでは、OpenBLAS の複数のバージョンが提供されることがあります。そのうち、マルチスレッドに対応するものもあれば、シリアル実行のみのものもあります。たとえば Fedora では、`libopenblasp.so` はスレッド対応ですが、`libopenblas.so` は対応していません。最適な性能を得るには、前者を使うことを推奨します。デフォルトの `libopenblas.so` とは異なる名前の OpenBLAS ライブラリを選ぶには、`make` に `LIBBLAS=-l$(YOURBLAS)` と `LIBBLASNAME=lib$(YOURBLAS)` を渡し、`$(YOURBLAS)` をライブラリ名に置き換えてください。バージョン番号のない `.so` シンボリックリンクがなくてもパッケージが動作するようにするには、ライブラリ名に `.so.0` を追加することもできます。

最後に、OpenBLAS には最適化された独自の LAPACK が含まれています。`USE_SYSTEM_BLAS=1` と `USE_SYSTEM_LAPACK=1` を設定する場合は、`LIBLAPACK=-l$(YOURBLAS)` と `LIBLAPACKNAME=lib$(YOURBLAS)` も設定してください。そうしないと、参照 LAPACK が使われ、通常は性能が大幅に低下します。

Julia 1.7 以降では、実行時に別の BLAS を選択するために [libblastrampoline](https://github.com/JuliaLinearAlgebra/libblastrampoline) を使います。

# Point releasing 101

ポイントリリース／パッチリリースの作成には、いくつかの独立した手順があります。

## Backporting commits

一部のプルリクエストには、「backport pending x.y」（例：「backport pending 0.6」）というラベルが付いています。これは、release-x.y ブランチから次にタグ付けされるリリースに、そのプルリクエストのコミットを含める必要があることを示します。プルリクエストが master にマージされたら、各コミットを専用ブランチに [cherry picked](https://git-scm.com/docs/git-cherry-pick) し、そのブランチを最終的に release-x.y にマージします。

### Creating a backports branch

まず、release-x.y をベースに新しいブランチを作成します。Julia のブランチ名は、個人用ブランチの場合、通常は作成者のイニシャルを先頭に付けます。ここでは、ブランチの作成者を Jane Smith とします。

```
git fetch origin
git checkout release-x.y
git rebase origin/release-x.y
git checkout -b js/backport-x.y
```

これにより、新しいブランチを作成する前に、ローカルの release-x.y が origin の最新状態に更新されます。

### Cherry picking commits

ここから実際にバックポートを行います。GitHub のウェブ UI で、「backport pending x.y」ラベルが付いた、マージ済みのプルリクエストをすべて探します。それぞれのページの下部に移動し、「someperson merged commit `123abc` into `master` XX minutes ago」と表示されている箇所を確認してください。コミット名はリンクになっており、クリックするとコミットの内容が表示されます。このページで `123abc` がマージコミットだと分かった場合は、PR のページに戻ってください。必要なのは実際のコミットであり、マージコミットではありません。一方、マージコミットでなければ、その PR は squash merge されています。その場合は、このページで commit の横に表示されている git SHA を使います。

コミットの SHA が分かったら、バックポート用ブランチに cherry-pick します。

```
git cherry-pick -x -e <sha>
```

手動で解決する必要のある競合が発生する場合があります。競合があれば解決したうえで、コミットメッセージの本文に、そのコミットを導入した GitHub のプルリクエストへの参照を追加してください。

関連するコミットをすべてバックポート用ブランチに取り込んだら、そのブランチを GitHub に push します。

## Checking for performance regressions

ポイントリリースで性能が低下することは、決してあってはなりません。幸い、Julia のベンチマークボット Nanosoldier は、master だけでなく任意のブランチに対してベンチマークを実行できます。ここでは、js/backport-x.y のベンチマーク結果を release-x.y と比較します。バックポート用プルリクエストにコメントを投稿し、ロボットの眠りについている Nanosoldier を起動してください。

```markdown
@nanosoldier `runbenchmarks(ALL, vs=":release-x.y")`
```

release-x.y と js/backport-x.y で登録済みのベンチマークがすべて実行され、改善点と性能低下を示す結果の概要が作成されます。

Nanosoldier が性能低下を検出した場合は、必要に応じてローカルで確認し、Nanosoldier を再実行してください。性能低下がノイズではなく実際に起きていると判断された場合は、修正するコミットが master にあれば、それをバックポートする必要があります。該当するコミットがなければ、性能低下の原因を特定し、パッチを提出する（または、コードに詳しい人にパッチを提出してもらう）必要があります。パッチが master にマージされたら、そのコミットをバックポートしてください。（適切であれば、バックポート用ブランチに直接パッチを提出してもかまいません。）

## Building test binaries

バックポート PR が `release-x.y` ブランチにマージされたら、Julia のローカルクローンを更新し、次のコマンドでブランチの SHA を取得します。

```
git rev-parse origin/release-x.y
```

この SHA は、buildbot の UI の「Revision」欄に入力するので、手元に控えておいてください。

現時点で必要なのは Linux x86-64 向けのバイナリだけです。PackageEvaluator の実行に使うのがこのバイナリだからです。https://buildog.julialang.org, にアクセスして `nuke_linux64` のジョブを送信し、続けて `package_linux64` のジョブをキューに追加して、Revision に SHA を指定します。パッケージ作成ジョブが完了すると、バイナリが AWS の `julialang2` バケットにアップロードされます。PackageEvaluator で使うため、その URL を取得してください。

## Checking for package breakages

ポイントリリースでパッケージが壊れることは、決してあってはなりません。ただし、ユーザー向けではない Base の内部機能を使って、かなり問題のあるハックを行っているパッケージは例外となる可能性があります。（その場合は、パッケージの作者に相談してもよいでしょう。）

次期バージョンの変更によってパッケージが壊れるかどうかは、[PackageEvaluator](https://github.com/JuliaCI/PackageEvaluator.jl) を使って確認できます。これは一般に「PkgEval」と略されます。PkgEval は、GitHub リポジトリや pkg.julialang.org のステータスバッジに表示される結果を生成します。通常は Nanosoldier のベンチマーク用ではないノードのいずれかで実行され、Vagrant を使って、独立した VirtualBox 仮想マシン上で並列に処理を行います。

### Setting up PackageEvaluator

PackageEvaluator をクローンし、`backport-x.y.z` というブランチを作成してチェックアウトします。必要な変更は少々その場しのぎで分かりにくく、将来の PackageEvaluator のバージョンで改善されることを期待しています。変更内容は [this commit](https://github.com/JuliaCI/PackageEvaluator.jl/commit/5ba6a3b000e7a3793391d16f695c8704b91d6016) を参考にしてください。

セットアップスクリプトは、第1引数を実行する Julia のバージョン、第2引数をパッケージ名の範囲（AK は A〜K で始まるパッケージ、LZ は L〜Z で始まるパッケージ）として受け取ります。ここでは少し変更を加え、現在の x.y リリースとバックポート版の2つの Julia バージョンだけを使い、それぞれでパッケージを3つの範囲に分けて実行します。

リンク先の差分では、第2引数が LZ の場合はバックポート用ブランチからビルドしたバイナリを使い、それ以外（AK）の場合はリリース版のバイナリを使うようにしています。次に第1引数を使って、パッケージ一覧の一部を実行します。入力が 0.4 の場合は A-F、0.5 の場合は G-N、0.6 の場合は O-Z です。

### Running PackageEvaluator

PkgEval を実行するには、十分な性能のマシン（Nanosoldier のノード1など）を用意し、次を実行します。

```
git clone https://github.com/JuliaCI/PackageEvaluator.jl.git
cd PackageEvaluator.jl/scripts
git checkout backport-x.y.z
./runvagrant.sh
```

これにより scripts/ ディレクトリにいくつかのフォルダーが作成されます。フォルダー名とその内容は次のとおりです。

| フォルダー名 | Julia のバージョン | パッケージの範囲 |
|:------:|:------------:|:--------:|
| 0.4AK  |     リリース     |   A-F    |
| 0.4LZ  |    バックポート    |   A-F    |
| 0.5AK  |     リリース     |   G-N    |
| 0.5LZ  |    バックポート    |   G-N    |
| 0.6AK  |     リリース     |   O-Z    |
| 0.6LZ  |    バックポート    |   O-Z    |

### Investigating results

完了したら、同じディレクトリにある `./summary.sh` を使って、結果の概要レポートを作成できます。バージョンごとの結果を集計するため、各フォルダーについて実行します。

```
./summary.sh 0.4AK/*.json > summary_release.txt
./summary.sh 0.5AK/*.json >> summary_release.txt
./summary.sh 0.6AK/*.json >> summary_release.txt
./summary.sh 0.4LZ/*.json > summary_backport.txt
./summary.sh 0.5LZ/*.json >> summary_backport.txt
./summary.sh 0.6LZ/*.json >> summary_backport.txt
```

これで、2つのバージョンについて、各パッケージの PackageEvaluator テスト結果（成功／失敗）を含む `summary_release.txt` と `summary_backport.txt` の2つのファイルが得られます。

Julia で扱いやすくするため、これらを CSV ファイルに変換してから、DataFrames パッケージで結果を処理します。CSV に変換するには、各 .txt ファイルを対応する .csv ファイルにコピーし、Vim を開いて `ggVGI"<esc>`、続けて `:%s/\.json /",/g` を実行します。（Vim を使う必要はありません。これは一つの方法です。）次に、以下のような Julia コードで結果を処理します。

```julia
using DataFrames

release = readtable("summary_release.csv", header=false, names=[:package, :release])
backport = readtable("summary_backport.csv", header=false, names=[:package, :backport])

results = join(release, backport, on=:package, kind=:outer)

for result in eachrow(results)
    a = result[:release]
    b = result[:backport]
    if (isna(a) && !isna(b)) || (isna(b) && !isna(a))
        color = :yellow
    elseif a != b && occursin("pass", b)
        color = :green
    elseif a != b
        color = :red
    else
        continue
    end
    printstyled(result[:package], ": Release ", a, " -> Backport ", b, "\n", color=color)
end
```

結果は、色分けされた行として `stdout` に出力されます。赤い行は、バックポート版によって問題が発生した可能性を示すため、すべて調査する必要があります。黄色い行は、何らかの理由で一方のバージョンではパッケージが実行されたものの、もう一方では実行されなかったことを示すため、確認してください。バックポート用ブランチが問題を引き起こしていると分かった場合は、`git bisect` を使って問題のあるコミットを特定し、そのコミットを `git revert` してから、同じ手順を繰り返します。

## Merging backports into the release branch

次のことを確認できたら、

  * バックポートしたコミットが Julia のユニットテストにすべて合格していること
  * バックポートしたコミットによって、リリースブランチと比べて性能が低下していないこと
  * バックポートしたコミットによって、登録済みのパッケージが壊れていないこと

バックポート用ブランチを release-x.y にマージする準備が整っています。マージ後、バックポートしたコミットを含むすべてのプルリクエストから「backport pending x.y」ラベルを削除してください。バックポートしていない PR からは、このラベルを削除しないでください。

これで release-x.y ブランチには、新しいコミットがすべて含まれているはずです。最後に行うのは、ブランチのバージョン番号の調整です。release-x.y に対して PR を提出し、VERSION ファイルを編集して、バージョン番号から `-pre` を削除します。これがマージされたら、タグ付けの準備は完了です。

## Tagging the release

いよいよタグ付けです。release-x.y ブランチをチェックアウトし、ローカルのブランチがリモートの最新状態になっていることを確認してください。コマンドラインで次を実行します。

```
git tag v$(cat VERSION)
git push --tags
```

これにより、ローカルにタグが作成され、GitHub に push されます。

リリースにタグを付けた後、release-x.y に対して別の PR を提出し、パッチ番号を上げて、末尾に `-pre` を追加します。これは、ブランチの状態が x.y 系列の次のポイントリリースのプレリリース版であることを示します。

残りの手順は Makefile の指示に従ってください。

## Signing binaries

これらの手順の一部では、パスワードが必要になります。必要なパスワードは Elliot Saba（staticfloat）または Alex Arslan（ararslan）に問い合わせてください。各プラットフォームのコード署名は、そのプラットフォーム上で行う必要があります（例：Windows の署名は Windows 上で行います）。

### Linux

Linux ではコード署名を手動で行う必要がありますが、手順は簡単です。まず、`juliasecure` AWS バケットの CodeSigning フォルダーから `julia.key` ファイルを取得します。次のコマンドで GnuPG のキーリングに追加してください。

```
gpg --import julia.key
```

このとき、Elliot または Alex に問い合わせて入手したパスワードの入力が必要です。次に、その鍵の信頼度を最大に設定します。まず、`gpg` セッションを開始します。

```
gpg --edit-key julia
```

プロンプトで `trust` と入力し、信頼度を尋ねられたら、選択可能な最大値（おそらく 5）を指定します。GnuPG を終了してください。

次に、buildbot でビルドした Linux の各 tarball に対して、次を実行します。

```
gpg -u julia --armor --detach-sig julia-x.y.z-linux-<arch>.tar.gz
```

各 tarball に対応する .asc ファイルが作成されます。これで完了です。

### macOS

macOS の buildbot では、コード署名が自動的に行われるはずです。ただし、署名が成功したことを確認する必要があります。macOS を実行しているシステムまたは仮想マシンで、buildbot が作成した .dmg ファイルをダウンロードします。例として、.dmg ファイル名を `julia-x.y.z-osx.dmg` とします。次を実行してください。

```
mkdir ./jlmnt
hdiutil mount -readonly -mountpoint ./jlmnt julia-x.y.z-osx.dmg
codesign -v jlmnt/Julia-x.y.app
```

マウント時に表示されるディスク名を必ず確認してください。ここでは例として `disk3` とします。コード署名の検証に成功した場合、`codesign` の実行時に何も出力されません。検証に成功したら、.dmg を取り外せます。

```
hdiutil eject /dev/disk3
rm -rf ./jlmnt
```

次のようなメッセージが表示された場合、

> Julia-x.y.app: code object is not signed at all


手動で署名する必要があります。

手動で署名するには、まず AWS の `juliasecure` バケットにある CodeSigning フォルダーから OS X の証明書を取得します。.p12 ファイルを Keychain.app でキーチェーンに追加してください。鍵のパスワードは Elliot Saba（staticfloat）または Alex Arslan（ararslan）に問い合わせてください。次を実行します。

```
hdiutil convert julia-x.y.z-osx.dmg -format UDRW -o julia-x.y.z-osx_writable.dmg
mkdir ./jlmnt
hdiutil mount -mountpoint julia-x.y.z-osx_writable.dmg
codesign -s "AFB379C0B4CBD9DB9A762797FC2AB5460A2B0DBE" --deep jlmnt/Julia-x.y.app
```

次のようなメッセージが表示され、失敗することがあります。

> Julia-x.y.app: resource fork, Finder information, or similar detritus not allowed


その場合は、余分な属性を削除する必要があります。

```
xattr -cr jlmnt/Julia-x.y.app
```

その後、コード署名を再試行してください。エラーが出なければ、検証も再試行します。問題がなければ、書き込み可能な .dmg をアンマウントし、読み取り専用に戻します。

```
hdiutil eject /dev/disk3
rm -rf ./jlmnt
hdiutil convert julia-x.y.z-osx_writable.dmg -format UDZO -o julia-x.y.z-osx_fixed.dmg
```

.dmg をダブルクリックして、修正後のファイルが正常であることを確認してください。問題がなければ、取り出して、ファイル名から `_fixed` の接尾辞を削除します。これで完了です。

### Windows

Windows では署名を手動で行う必要があります。まず、必要な署名ユーティリティが含まれている Windows 10 SDK を Microsoft のウェブサイトから入手します。必要なのは `SignTool` ユーティリティで、`C:\Program Files (x86)\Windows Kits\10\App Certification Kit` のような場所にインストールされているはずです。CodeSigning の Windows 証明書ファイルを `juliasecure` から取得し、実行ファイルと同じディレクトリに置きます。Windows の CMD ウィンドウを開き、すべてのファイルがある場所に `cd` してから、次を実行します。

```
set PATH=%PATH%;C:\Program Files (x86)\Windows Kits\10\App Certification Kit;
signtool sign /f julia-windows-code-sign_2017.p12 /p "PASSWORD" ^
   /t http://timestamp.verisign.com/scripts/timstamp.dll ^
   /v julia-x.y.z-win32.exe
```

`^` は Windows CMD の行継続文字で、`PASSWORD` は証明書のパスワードを表すプレースホルダーです。パスワードは、いつものように Elliot または Alex に問い合わせてください。エラーがなければ完了です。

## Uploading binaries

すべての署名が終わったら、バイナリを AWS にアップロードします。Cyberduck のようなプログラムか、コマンドラインユーティリティの `aws` を使えます。バイナリは、適切なフォルダーにある `julialang2` バケットに配置してください。たとえば、Linux x86-64 向けのものは `julialang2/bin/linux/x.y` に配置します。現在の `julia-x.y-latest-linux-<arch>.tar.gz` ファイルを削除し、`julia-x.y.z-linux-<arch>.tar.gz` の複製に置き換えてください。

ビルドしたソース tarball とすべてのリリースバイナリを含め、作成したすべてのファイルのチェックサムもアップロードする必要があります。手順は簡単です。

```
shasum -a 256 julia-x.y.z* | grep -v -e sha256 -e md5 -e asc > julia-x.y.z.sha256
md5sum julia-x.y.z* | grep -v -e sha256 -e md5 -e asc > julia-x.y.z.md5
```

macOS でこれらのコマンドを実行すると、出力がわずかに異なります。既存のファイルを参考にして書式を整えてください。また、Mac ユーザーは `md5sum` の代わりに `md5 -r` を使う必要があります。.md5 ファイルと .sha256 ファイルを AWS の `julialang2/bin/checksums` にアップロードしてください。

AWS にアップロードしたすべてのファイルのアクセス権が「Everyone: READ」に設定されていることを確認してください。

アップロードした各ファイルについて、ウェブサイト上のリンクが更新後のファイルを指すように、Fastly のキャッシュを消去する必要があります。例を示します。

```
curl -X PURGE https://julialang-s3.julialang.org/bin/checksums/julia-x.y.z.sha256
```

不要な場合もありますが、実行しておくとよいでしょう。
