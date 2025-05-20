# Binary distributions

これらのノートは、さまざまなプラットフォームで配布するためのJuliaのバイナリディストリビューションをコンパイルしたい人々のためのものです。私たちは、ユーザーができるだけ多くの場所でJuliaを広め、できるだけ多くのオペレーティングシステムやハードウェア構成で試してみることを愛しています。各プラットフォームには、ポータブルで動作するJuliaディストリビューションを作成するために従うべき特定の注意点やプロセスがあるため、ほとんどのノートをOSごとに分けています。

注意してください。Juliaのコードは [MIT-licensed, with a few exceptions](https://github.com/JuliaLang/julia/blob/master/LICENSE.md) ですが、ここで説明されている技術によって作成された配布物はGPLライセンスになります。これは、`SuiteSparse`などのさまざまな依存ライブラリがGPLライセンスであるためです。将来的には非GPLのJulia配布物を持つことを希望しています。

## Versioning and Git

Makefileは、`VERSION`ファイルとgitリポジトリからのコミットハッシュおよびタグの両方を使用して、スプラッシュスクリーンと`versioninfo()`出力を埋めるために使用する情報を含む`base/version_git.jl`を生成します。何らかの理由でビルド時にgitリポジトリを利用したくない場合は、次のコマンドで`base/version_git.jl`ファイルを事前に生成する必要があります。

```
make -C base version_git.jl.phony
```

Juliaには、多くのビルド依存関係があり、人気のあるパッケージマネージャーにまだ含まれていないパッチ版を使用しています。これらの依存関係は通常、ビルド時に自動的にダウンロードされますが、インターネットに接続されていないコンピュータでJuliaをビルドできるようにするには、特別なmakeターゲットを使用してフルソースディストリビューションアーカイブを作成する必要があります。

```
make full-source-dist
```

それは、必要な依存関係をすべて含む julia-version-commit.tar.gz アーカイブを作成します。

タグ付きリリースをgitリポジトリでコンパイルする際、スプラッシュスクリーンにブランチ/コミットハッシュ情報は表示しません。この行を使用して、最大45文字のリリース説明を表示できます。この行を設定するには、Make.userファイルを作成する必要があります。

```
override TAGGED_RELEASE_BANNER = "my-package-repository build"
```

## Target Architectures

デフォルトでは、Juliaはビルドマシンのネイティブアーキテクチャに最適化されたシステムイメージを生成します。これは通常、パッケージをビルドする際には望ましくなく、互換性のないCPU（特に、より制限された命令セットを持つ古いCPU）を持つ任意のマシンでJuliaが起動に失敗する原因となります。

したがって、`make`を呼び出す際に`MARCH`変数を渡し、サポートする予定のベースラインターゲットに設定することをお勧めします。これにより、Julia実行可能ファイルとライブラリ、システムイメージのターゲットCPUが決まります（後者は[`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET)を使用して設定することもできます）。x86 CPUにとって通常有用な値は、`x86-64`および`core2`（64ビットビルド用）と`pentium4`（32ビットビルド用）です。残念ながら、Pentium 4より古いCPUは現在サポートされていません（[this issue](https://github.com/JuliaLang/julia/issues/7185)を参照してください）。

LLVMがサポートするCPUターゲットの完全なリストは、`llc -mattr=help`を実行することで取得できます。

## Linux

Linuxでは、`make binary-dist`を実行すると、完全に機能するJuliaインストールを含むtarballが作成されます。`.deb`や`.rpm`のような配布パッケージを作成したい場合は、追加の作業が必要です。DebianおよびUbuntuベースのシステム用の`.deb`パッケージを作成するために必要なメタデータの例については、[julia-debian](https://github.com/staticfloat/julia-debian)リポジトリを参照してください。RPMベースのディストリビューションについては、[Fedora package](https://src.fedoraproject.org/rpms/julia)を参照してください。まだ実験はしていませんが、[Alien](https://wiki.debian.org/Alien)を使用して、さまざまなLinuxディストリビューション用のJuliaパッケージを生成することができるかもしれません。

Juliaは、`make`および`make install`を呼び出す際に渡すことができる`prefix`やその他の環境変数を介して標準のインストールディレクトリを上書きすることをサポートしています。これらのリストはMake.incに記載されています。`DESTDIR`を使用することで、一時ディレクトリへのインストールを強制することもできます。

デフォルトでは、Juliaはインストール全体の初期化ファイルとして`$prefix/etc/julia/startup.jl`を読み込みます。このファイルは、配布管理者がカスタムパスや初期化コードを設定するために使用できます。Linuxの配布パッケージの場合、`$prefix`が`/usr`に設定されていると、調べるべき`/usr/etc`は存在しません。これにより、Juliaのプライベート`etc`ディレクトリへのパスを変更する必要があります。これは、ビルド時に`sysconfdir`メイク変数を介して行うことができます。ビルド時に`make`に`sysconfdir=/etc`を渡すだけで、Juliaは最初に`/etc/julia/startup.jl`をチェックし、その後に`$prefix/etc/julia/startup.jl`を試みます。

## OS X

OSXでバイナリ配布を作成するには、まずJuliaをビルドし、その後`contrib/mac/app`に移動し、Julia本体をビルドする際に使用したのと同じmakevarsで`make`を実行します。これにより、完全に自己完結したJulia.appを含む`.dmg`ファイルが`contrib/mac/app`ディレクトリに作成されます。

代わりに、Juliaは`make`を`darwinframework`ターゲットで呼び出し、`DARWIN_FRAMEWORK=1`を設定することでフレームワークとしてビルドできます。例えば、`make DARWIN_FRAMEWORK=1 darwinframework`。

## Windows

Windows上でのJuliaディストリビューションの作成に関する手順は、[build devdocs for Windows](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/windows.md)に記載されています。

## Notes on BLAS and LAPACK

JuliaはデフォルトでOpenBLASをビルドし、BLASおよびLAPACKライブラリを含みます。32ビットアーキテクチャでは、Juliaは32ビット整数を使用するようにOpenBLASをビルドし、64ビットアーキテクチャでは64ビット整数（ILP64）を使用するようにOpenBLASをビルドします。BLASおよびLAPACK APIルーチンを呼び出すすべてのJulia関数が正しい幅の整数を使用することが重要です。

ほとんどのBLASおよびLAPACKの配布物はLinuxディストリビューションで提供されており、商用実装でも32ビットAPIを使用するライブラリが出荷されています。多くの場合、64ビットAPIは別のライブラリとして提供されています。

ベンダー提供またはOS提供のライブラリを使用する際、Juliaビルドの一部として`USE_BLAS64`という`make`オプションが利用可能です。`make USE_BLAS64=0`を実行すると、Juliaは64ビットアーキテクチャ上でもすべての整数が32ビット幅であると仮定して、32ビットAPIを前提にBLASおよびLAPACKを呼び出します。

他のライブラリ、例えばSuiteSparseも内部でBLASとLAPACKを使用しています。APIは、BLASとLAPACKに依存するすべてのライブラリで一貫性を保つ必要があります。Juliaのビルドプロセスは、これらのライブラリを正しくビルドしますが、デフォルトをオーバーライドしてシステム提供のライブラリを使用する場合、この一貫性を確保する必要があります。

また、Linuxディストリビューションは、マルチスレッドを有効にしたバージョンと、シリアル方式でのみ動作するバージョンのいくつかを含むOpenBLASの複数のバージョンを出荷することがあります。たとえば、Fedoraでは、`libopenblasp.so`はスレッド対応ですが、`libopenblas.so`はそうではありません。最適なパフォーマンスのために前者を使用することをお勧めします。デフォルトの`libopenblas.so`とは異なる名前のOpenBLASライブラリを選択するには、`make`に`LIBBLAS=-l$(YOURBLAS)`および`LIBBLASNAME=lib$(YOURBLAS)`を渡し、`$(YOURBLAS)`をライブラリの名前に置き換えます。バージョンなしの`.so`シンボリックリンクを必要とせずにパッケージを動作させたい場合は、ライブラリの名前に`.so.0`を追加することもできます。

最後に、OpenBLASには独自の最適化されたLAPACKバージョンが含まれています。`USE_SYSTEM_BLAS=1`および`USE_SYSTEM_LAPACK=1`を設定した場合は、`LIBLAPACK=-l$(YOURBLAS)`および`LIBLAPACKNAME=lib$(YOURBLAS)`も設定する必要があります。そうしないと、参照LAPACKが使用され、パフォーマンスは通常はるかに低くなります。

Julia 1.7以降、Juliaは[libblastrampoline](https://github.com/JuliaLinearAlgebra/libblastrampoline)を使用して、実行時に異なるBLASを選択します。

# Point releasing 101

ポイント/パッチリリースの作成は、いくつかの異なるステップで構成されています。

## Backporting commits

いくつかのプルリクエストには「backport pending x.y」というラベルが付けられています。例えば、「backport pending 0.6」です。これは、release-x.yブランチからタグ付けされた次のリリースに、そのプルリクエストのコミットが含まれるべきであることを示しています。プルリクエストがマスターにマージされると、各コミットは [cherry picked](https://git-scm.com/docs/git-cherry-pick) という専用のブランチに移され、最終的にrelease-x.yにマージされることになります。

### Creating a backports branch

まず、release-x.yを基に新しいブランチを作成します。Juliaのブランチの一般的な命名規則は、個人用のブランチである場合、ブランチ名の先頭にイニシャルを付けることです。例として、ブランチの作成者がジェーン・スミスであるとしましょう。

```
git fetch origin
git checkout release-x.y
git rebase origin/release-x.y
git checkout -b js/backport-x.y
```

これにより、新しいブランチを作成する前に、リリース-x.yのローカルコピーがoriginと最新の状態であることが保証されます。

### Cherry picking commits

実際のバックポート作業を行います。「backport pending x.y」とラベル付けされたすべてのマージされたプルリクエストをGitHubのWeb UIで見つけます。これらの各プルリクエストの下部にスクロールし、「someperson merged commit `123abc` into `master` XX minutes ago」と表示されている部分を確認します。コミット名はリンクになっているので、クリックするとコミットの内容が表示されます。このページで`123abc`がマージコミットである場合は、PRページに戻ります。マージコミットは不要で、実際のコミットが必要です。しかし、これがマージコミットでない場合は、PRがスクワッシュマージされたことを意味します。その場合は、このページに表示されているコミットの横にあるgit SHAを使用します。

コミットのSHAを取得したら、それをバックポート用のブランチにチェリーピックします：

```
git cherry-pick -x -e <sha>
```

手動で解決する必要がある競合が発生する場合があります。競合が解決されたら（該当する場合）、コミットメッセージの本文にそのコミットを導入したGitHubプルリクエストへの参照を追加してください。

すべての関連するコミットがバックポートブランチにあることを確認したら、そのブランチをGitHubにプッシュします。

## Checking for performance regressions

ポイントリリースはパフォーマンスの低下を引き起こすべきではありません。幸いなことに、JuliaのベンチマークボットであるNanosoldierは、masterだけでなく任意のブランチに対してベンチマークを実行できます。この場合、js/backport-x.yのベンチマーク結果をrelease-x.yと比較したいと思います。これを行うには、バックポートのプルリクエストにコメントをしてNanosoldierをロボットの眠りから呼び覚まします：

```markdown
@nanosoldier `runbenchmarks(ALL, vs=":release-x.y")`
```

これにより、release-x.yおよびjs/backport-x.yで登録されたすべてのベンチマークが実行され、結果の要約が生成され、すべての改善点と後退がマークされます。

Nanosoldierがリグレッションを見つけた場合は、ローカルで確認し、必要に応じてNanosoldierを再実行してください。リグレッションが単なるノイズではなく実際のものであると判断された場合は、それを修正するためのマスターブランチのコミットを見つけてバックポートする必要があります。もし存在しない場合は、リグレッションの原因を特定し、マスターにパッチを提出する（またはコードを知っている誰かにパッチを提出してもらう）必要があります。その後、マージされたらコミットをバックポートします。（または、適切であればバックポートブランチに直接パッチを提出してください。）

## Building test binaries

バックポートPRが`release-x.y`ブランチにマージされた後、ローカルのJuliaクローンを更新し、次のコマンドを使用してブランチのSHAを取得します。

```
git rev-parse origin/release-x.y
```

それを手元に置いておいてください。ビルドボットのUIの「Revision」フィールドに入力する内容です。

今のところ、PackageEvaluatorを実行するために必要なのはLinux x86-64用のバイナリだけです。https://buildog.julialang.org にアクセスし、`nuke_linux64`のジョブを提出し、その後、SHAをリビジョンとして指定して`package_linux64`のジョブをキューに追加します。パッケージングジョブが完了すると、バイナリがAWSの`julialang2`バケットにアップロードされます。URLを取得してください。これはPackageEvaluatorで使用されます。

## Checking for package breakages

ポイントリリースは、パッケージを壊すべきではありません。ユーザー向けではないBaseの内部を使って非常に疑わしいハックを行っているパッケージに関しては、例外があるかもしれません。（その場合は、パッケージの作者と話をすることをお勧めします。）

今後の新バージョンで行われた変更がパッケージを壊すかどうかを確認するには、[PackageEvaluator](https://github.com/JuliaCI/PackageEvaluator.jl)を使用します。これは一般に「PkgEval」と呼ばれています。PkgEvalは、GitHubリポジトリやpkg.julialang.orgのステータスバッジを表示する役割を果たします。通常、Nanosoldierのベンチマークを行わないノードの1つで実行され、Vagrantを使用して、別々の並列VirtualBox仮想マシンでその任務を遂行します。

### Setting up PackageEvaluator

パッケージ評価者をクローンし、`backport-x.y.z`というブランチを作成してチェックアウトしてください。必要な変更は少しハッキーで混乱を招くものであり、将来的にはパッケージ評価者の新しいバージョンで対処されることを期待しています。行うべき変更は、[this commit](https://github.com/JuliaCI/PackageEvaluator.jl/commit/5ba6a3b000e7a3793391d16f695c8704b91d6016)をモデルにします。

セットアップスクリプトは、最初の引数として実行するJuliaのバージョンを、2番目の引数としてパッケージ名の範囲（A-Kの場合はAK、L-Zの場合はLZ）を取ります。基本的なアイデアは、現在のx.yリリースとバックポートバージョンの2つのJuliaバージョンのみを実行し、それぞれに3つのパッケージ範囲を設定することです。

リンクされた差分では、2番目の引数がLZの場合はバックポートブランチからビルドされたバイナリを使用し、それ以外（AK）の場合はリリースバイナリを使用することを示しています。次に、最初の引数を使用してパッケージリストのセクションを実行します：入力0.4の場合はA-F、0.5の場合はG-N、0.6の場合はO-Zです。

### Running PackageEvaluator

PkgEvalを実行するには、十分な性能を持つマシン（例えばNanosoldierノード1）を見つけて、次に実行します。

```
git clone https://github.com/JuliaCI/PackageEvaluator.jl.git
cd PackageEvaluator.jl/scripts
git checkout backport-x.y.z
./runvagrant.sh
```

このスクリプトは、scripts/ ディレクトリ内にいくつかのフォルダーを生成します。フォルダー名とその内容は以下にデコードされています:

| Folder name | Julia version | Package range |
|:-----------:|:-------------:|:-------------:|
|    0.4AK    |    Release    |      A-F      |
|    0.4LZ    |   Backport    |      A-F      |
|    0.5AK    |    Release    |      G-N      |
|    0.5LZ    |   Backport    |      G-N      |
|    0.6AK    |    Release    |      O-Z      |
|    0.6LZ    |   Backport    |      O-Z      |

### Investigating results

それが完了したら、同じディレクトリから `./summary.sh` を使用して、調査結果の要約レポートを作成できます。各フォルダーについてこれを行い、バージョンごとの全体的な結果を集約します。

```
./summary.sh 0.4AK/*.json > summary_release.txt
./summary.sh 0.5AK/*.json >> summary_release.txt
./summary.sh 0.6AK/*.json >> summary_release.txt
./summary.sh 0.4LZ/*.json > summary_backport.txt
./summary.sh 0.5LZ/*.json >> summary_backport.txt
./summary.sh 0.6LZ/*.json >> summary_backport.txt
```

現在、`summary_release.txt` と `summary_backport.txt` の2つのファイルがあり、それぞれのバージョンに対する各パッケージのPackageEvaluatorテスト結果（合格/不合格）が含まれています。

これらをJuliaに取り込むのを簡単にするために、CSVファイルに変換し、その後DataFramesパッケージを使用して結果を処理します。CSVに変換するには、各.txtファイルを対応する.csvファイルにコピーし、次にVimを開いて`ggVGI"<esc>`を実行し、次に`:%s/\.json /",/g`を入力します。（Vimを使用する必要はありません。これは単なる一つの方法です。）次に、以下のようなJuliaコードを使用して結果を処理します。

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

これは `stdout` に色分けされた行を書き込みます。赤い行は、バックポートバージョンによって引き起こされる可能性のある障害を示しているため、調査する必要があります。黄色の行は、何らかの理由で一方のバージョンではパッケージが実行されたが、もう一方では実行されなかったことを意味するため、確認する必要があります。バックポートされたブランチが障害を引き起こしていることがわかった場合は、`git bisect` を使用して問題のあるコミットを特定し、`git revert` でそれらのコミットを元に戻し、プロセスを繰り返してください。

## Merging backports into the release branch

その後、あなたが確認したら

  * バックポートされたコミットは、Juliaのすべてのユニットテストに合格します。
  * バックポートされたコミットによって、リリースブランチと比較してパフォーマンスの後退は発生していません、そして
  * バックポートされたコミットは、登録されたパッケージに影響を与えません。

その後、バックポートブランチはrelease-x.yにマージする準備が整います。マージが完了したら、バックポートされたコミットを含むすべてのプルリクエストから「backport pending x.y」ラベルを削除してください。バックポートされていないPRからはラベルを削除しないでください。

release-x.y ブランチにはすべての新しいコミットが含まれているはずです。ブランチに対して行いたい最後の作業は、バージョン番号を調整することです。これを行うために、VERSION ファイルを編集してバージョン番号から `-pre` を削除する PR を release-x.y に提出してください。それがマージされたら、タグ付けの準備が整います。

## Tagging the release

時間です！release-x.y ブランチをチェックアウトし、ローカルのブランチがリモートブランチと最新の状態であることを確認してください。コマンドラインで次のコマンドを実行します。

```
git tag v$(cat VERSION)
git push --tags
```

これにより、タグがローカルで作成され、GitHubにプッシュされます。

リリースにタグを付けた後、patch番号を上げ、末尾に`-pre`を追加するためにrelease-x.yに別のPRを提出してください。これは、ブランチの状態がx.yシリーズの次のポイントリリースのプレリリースバージョンを反映していることを示します。

Makefileの残りの指示に従ってください。

## Signing binaries

これらの手順のいくつかには、安全なパスワードが必要です。適切なパスワードを取得するには、Elliot Saba (staticfloat) または Alex Arslan (ararslan) に連絡してください。各プラットフォームのコード署名は、そのプラットフォーム上で実行する必要があることに注意してください（例：Windowsの署名はWindows上で行う必要があります）。

### Linux

コード署名はLinuxで手動で行う必要がありますが、非常に簡単です。まず、`juliasecure` AWSバケットのCodeSigningフォルダーからファイル`julia.key`を取得します。次に、以下のコマンドを使用してこれをGnuPGキーチェーンに追加します。

```
gpg --import julia.key
```

この操作には、ElliotまたはAlexから取得する必要があるパスワードの入力が必要です。次に、キーの信頼レベルを最大に設定します。まず、`gpg`セッションに入ります:

```
gpg --edit-key julia
```

プロンプトで `trust` と入力し、信頼レベルを尋ねられたら、利用可能な最大値（おそらく5）を提供します。GnuPGを終了します。

今、ビルドボットでビルドされた各Linuxターボールについて、入力してください。

```
gpg -u julia --armor --detach-sig julia-x.y.z-linux-<arch>.tar.gz
```

これにより、各ターボールに対応する .asc ファイルが生成されます。それだけです！

### macOS

コード署名は、macOSのビルドボットで自動的に行われるべきです。しかし、成功したことを確認することが重要です。macOSを実行しているシステムまたは仮想マシンで、ビルドボットでビルドされた.dmgファイルをダウンロードします。例として、.dmgファイルの名前が`julia-x.y.z-osx.dmg`だとしましょう。次のコマンドを実行します。

```
mkdir ./jlmnt
hdiutil mount -readonly -mountpoint ./jlmnt julia-x.y.z-osx.dmg
codesign -v jlmnt/Julia-x.y.app
```

マウント時に表示されるマウントディスクの名前を必ずメモしてください！例として、これを `disk3` と仮定します。コード署名の検証が成功した場合、`codesign` ステップからの出力はありません。実際に成功していれば、今すぐ .dmg を取り外すことができます：

```
hdiutil eject /dev/disk3
rm -rf ./jlmnt
```

メッセージのようなものを受け取った場合

> Julia-x.y.app: コードオブジェクトは全く署名されていません


その場合は手動で署名する必要があります。

手動で署名するには、まずAWSの`juliasecure`バケット内のCodeSigningフォルダーからOS X証明書を取得します。.p12ファイルをKeychain.appを使用してキーチェーンに追加します。キーのパスワードについては、Elliot Saba (staticfloat) または Alex Arslan (ararslan) に問い合わせてください。次に、実行します。

```
hdiutil convert julia-x.y.z-osx.dmg -format UDRW -o julia-x.y.z-osx_writable.dmg
mkdir ./jlmnt
hdiutil mount -mountpoint julia-x.y.z-osx_writable.dmg
codesign -s "AFB379C0B4CBD9DB9A762797FC2AB5460A2B0DBE" --deep jlmnt/Julia-x.y.app
```

これは「のようなメッセージで失敗する可能性があります。

> Julia-x.y.app: リソースフォーク、Finder情報、または同様の不要物は許可されていません


その場合、余分な属性を削除する必要があります：

```
xattr -cr jlmnt/Julia-x.y.app
```

その後、コード署名を再試行してください。それでエラーが発生しない場合は、検証を再試行してください。すべてが正常であれば、書き込み可能な.dmgをアンマウントし、再び読み取り専用に変換してください：

```
hdiutil eject /dev/disk3
rm -rf ./jlmnt
hdiutil convert julia-x.y.z-osx_writable.dmg -format UDZO -o julia-x.y.z-osx_fixed.dmg
```

結果の.dmgが実際に修正されていることをダブルクリックして確認してください。すべてが問題なければ、イジェクトしてから名前から`_fixed`のサフィックスを削除します。それで終わりです！

### Windows

署名はWindows上で手動で行う必要があります。まず、Microsoftのウェブサイトから必要な署名ユーティリティを含むWindows 10 SDKを取得します。`SignTool`ユーティリティが必要で、これは`C:\Program Files (x86)\Windows Kits\10\App Certification Kit`のような場所にインストールされているはずです。`juliasecure`のCodeSigningからWindows証明書ファイルを取得し、実行可能ファイルと同じディレクトリに置きます。Windows CMDウィンドウを開き、すべてのファイルがある場所に`cd`し、次のコマンドを実行します。

```
set PATH=%PATH%;C:\Program Files (x86)\Windows Kits\10\App Certification Kit;
signtool sign /f julia-windows-code-sign_2017.p12 /p "PASSWORD" ^
   /t http://timestamp.verisign.com/scripts/timstamp.dll ^
   /v julia-x.y.z-win32.exe
```

`^` は Windows CMD における行継続文字であり、`PASSWORD` はこの証明書のパスワードのプレースホルダーです。いつものように、パスワードについてはエリオットまたはアレックスに連絡してください。エラーがなければ、すべて問題ありません！

## Uploading binaries

すべての署名が完了したので、バイナリをAWSにアップロードする必要があります。Cyberduckのようなプログラムや`aws`コマンドラインユーティリティを使用できます。バイナリは適切なフォルダーに`julialang2`バケットに配置する必要があります。たとえば、Linux x86-64は`julialang2/bin/linux/x.y`に配置します。現在の`julia-x.y-latest-linux-<arch>.tar.gz`ファイルを削除し、`julia-x.y.z-linux-<arch>.tar.gz`の複製に置き換えることを忘れないでください。

私たちは、ビルドしたすべてのもの、ソースのtarballやすべてのリリースバイナリを含むチェックサムをアップロードする必要があります。これは簡単です：

```
shasum -a 256 julia-x.y.z* | grep -v -e sha256 -e md5 -e asc > julia-x.y.z.sha256
md5sum julia-x.y.z* | grep -v -e sha256 -e md5 -e asc > julia-x.y.z.md5
```

macOSでこれらのコマンドを実行している場合、出力がわずかに異なることに注意してください。既存のファイルを参照することで再フォーマットできます。Macユーザーは、`md5sum`の代わりに`md5 -r`を使用する必要があります。.md5および.sha256ファイルをAWSの`julialang2/bin/checksums`にアップロードしてください。

すべてのアップロードされたファイルのAWSの権限が「全員: 読み取り」に設定されていることを確認してください。

アップロードした各ファイルについて、ウェブサイトのリンクが更新されたファイルを指すように、Fastlyキャッシュを削除する必要があります。例として：

```
curl -X PURGE https://julialang-s3.julialang.org/bin/checksums/julia-x.y.z.sha256
```

時々これは必要ないこともありますが、やっておくのは良いことです。
