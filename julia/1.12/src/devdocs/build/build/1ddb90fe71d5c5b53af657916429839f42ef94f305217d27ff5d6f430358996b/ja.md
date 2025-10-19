# Building Julia (Detailed)

## Downloading the Julia source code

ファイアウォールの背後にいる場合は、`git`プロトコルの代わりに`https`プロトコルを使用する必要があるかもしれません:

```sh
git config --global url."https://".insteadOf git://
```

システムが適切なプロキシ設定を使用するように構成することも忘れないでください。たとえば、`https_proxy`および`http_proxy`変数を設定することによってです。

## Building Julia

初回コンパイル時に、ビルドは自動的にプリビルドされた [external dependencies](#Required-Build-Tools-and-External-Libraries) をダウンロードします。すべての依存関係を自分でビルドしたい場合や、ビルドプロセス中にネットワークにアクセスできないシステムでビルドしている場合は、`Make.user` に以下を追加してください：

```
USE_BINARYBUILDER=0
```

Juliaをビルドするには、すべての依存関係をビルドする場合に5GiB、仮想メモリとして約4GiBが必要です。

並列ビルドを実行するには、`make -j N`を使用し、同時に実行するプロセスの最大数を指定します。ビルドのデフォルトがうまくいかない場合や、特定のmakeパラメータを設定する必要がある場合は、それらを`Make.user`に保存し、そのファイルをJuliaソースのルートに置くことができます。ビルドは自動的に`Make.user`の存在を確認し、存在する場合はそれを使用します。

Juliaのアウトオブツリービルドを作成するには、コマンドラインで `make O=<build-directory> configure` を指定します。これにより、指定されたディレクトリにJuliaをビルドするために必要なすべてのMakefileを含むディレクトリミラーが作成されます。これらのビルドは、Juliaのソースファイルと `deps/srccache` を共有します。各アウトオブツリービルドディレクトリには、トップレベルフォルダのグローバル `Make.user` ファイルをオーバーライドするための独自の `Make.user` ファイルを持つことができます。

すべてが正しく動作すれば、Juliaのバナーと、評価のために式を入力できるインタラクティブなプロンプトが表示されます。（ライブラリに関連するエラーは、PATH内に古い互換性のないライブラリが存在することが原因かもしれません。この場合、`julia`ディレクトリをPATHの前方に移動してみてください）。上記の指示のほとんどはunixシステムに適用されることに注意してください。

どこからでもJuliaを実行するには、次のようにします：

  * エイリアスを追加します（`bash`の場合: `echo "alias julia='/path/to/install/folder/bin/julia'" >> ~/.bashrc && source ~/.bashrc`）、または
  * `julia` ディレクトリ内の `julia` 実行可能ファイルへのソフトリンクを `/usr/local/bin`（またはパスに既に含まれている適切なディレクトリ）に追加します。
  * このシェルセッションの実行可能パスに `julia` ディレクトリを追加します（`bash` の場合: `export PATH="$(pwd):$PATH"` ; `csh` または `tcsh` の場合:

`set path= ( $path $cwd )` ), または

  * `julia` ディレクトリを実行可能パスに永続的に追加します（例：`.bash_profile` で）、または
  * `Make.user`に`prefix=/path/to/install/folder`を書き込み、その後`make install`を実行します。このフォルダーにすでにインストールされているJuliaのバージョンがある場合は、`make install`を実行する前にそれを削除する必要があります。

Juliaのビルドを制御するために設定できるオプションのいくつかは、ファイル`Make.inc`の冒頭にリストされ、文書化されていますが、この目的のためにそれを編集するべきではなく、代わりに`Make.user`を使用してください。

JuliaのMakefileは、変数の値を印刷するための便利な自動ルール `print-<VARNAME>` を定義しています。ここで `<VARNAME>` は印刷する変数の名前に置き換えられます。例えば、

```console
$ make print-JULIA_PRECOMPILE
JULIA_PRECOMPILE=1
```

これらのルールはデバッグ目的で役立ちます。

今、あなたは次のようにJuliaを実行できるはずです：

```
julia
```

Linux、macOS、またはWindowsで配布するためのJuliaパッケージを構築している場合は、[distributing.md](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/distributing.md)の詳細なノートを確認してください。

## Updating an existing source tree

以前に `git clone` を使用して `julia` をダウンロードした場合は、新たに始めるのではなく、`git pull` を使用して既存のソースツリーを更新できます。

```sh
cd julia
git pull && make
```

ソースツリーにアップストリームの更新と競合する変更を加えていないと仮定すると、これらのコマンドは最新バージョンに更新するためのビルドをトリガーします。

## General troubleshooting

1. 時間が経つにつれて、ベースライブラリに十分な変更が蓄積されると、システムイメージを構築する際のブートストラッププロセスが失敗する可能性があります。これが発生した場合、ビルドは次のようなエラーで失敗する可能性があります。

    ```sh
     *** This error is usually fixed by running 'make clean'. If the error persists, try 'make cleanall' ***
    ```

    説明したように、`make clean && make`を実行することが通常は十分です。時々、`make cleanall`によるより強力なクリーンアップが必要になります。
2. 新しいバージョンの外部依存関係が導入されることがあり、これが時折、古いバージョンの既存ビルドと衝突を引き起こす可能性があります。

    a. 特別な `make` ターゲットが存在し、依存関係の既存のビルドを消去するのに役立ちます。例えば、`make -C deps clean-llvm` は、既存の `llvm` のビルドをクリーンアップし、次回 `make` が呼び出されたときに `llvm` がダウンロードされたソース配布から再ビルドされるようにします。`make -C deps distclean-llvm` は、より強力な消去で、ダウンロードされたソース配布も削除されるため、次回 `make` が呼び出されたときに新しいソース配布のコピーがダウンロードされ、新しいパッチが適用されることが保証されます。

    b. 既存の `julia` とそのすべての依存関係のバイナリを削除するには、ソースツリー内の `./usr` ディレクトリを削除してください。
3. 最近macOSを更新した場合は、`xcode-select --install`を実行してコマンドラインツールを更新してください。そうしないと、`ld: library not found for -lcrt1.10.6.o`のようなヘッダーやライブラリが見つからないエラーが発生する可能性があります。
4. ソースディレクトリを移動した場合、`CMake Error: The current CMakeCache.txt directory ... is different than the directory ... where CMakeCache.txt was created.` のようなエラーが発生することがあります。この場合、`deps`の下にある問題のある依存関係を削除することができます。
5. 極端な場合、ソースツリーを元の状態にリセットしたいかもしれません。以下のgitコマンドが役立つかもしれません：

    ```sh
     git reset --hard #Forcibly remove any changes to any files under version control
     git clean -x -f -d #Forcibly remove any file or directory not under version control
    ```

    *作業を失わないように、これらのコマンドが何をするのかを実行する前に確認してください。`git`はこれらの変更を元に戻すことができません！*

## Platform-Specific Notes

さまざまなオペレーティングシステムのノート:

  * [Linux](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/linux.md)
  * [macOS](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/macos.md)
  * [Windows](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/windows.md)
  * [FreeBSD](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/freebsd.md)

さまざまなアーキテクチャに関するノート:

  * [ARM](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/arm.md)
  * [RISC-V](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/riscv.md)

## Required Build Tools and External Libraries

Juliaをビルドするには、以下のソフトウェアがインストールされている必要があります：

  * **[GNU make]**                — 依存関係の構築。
  * **[gcc & g++][gcc]** (>= 7.1) または **[Clang][clang]** (>= 5.0, Apple Clang の場合は >= 9.3) — C, C++ のコンパイルとリンク。
  * **[libatomic][gcc]**          — **[gcc]** によって提供され、アトミック操作をサポートするために必要です。
  * **[python]** (>=2.7)          — LLVMをビルドするために必要です。
  * **[gfortran]**                — Fortranライブラリのコンパイルとリンク。
  * **[perl]**                    — ライブラリのヘッダーファイルの前処理。
  * **[wget]**, **[curl]**, または **[fetch]** (FreeBSD) — 外部ライブラリを自動的にダウンロードするために。
  * **[m4]**                      — GMPをビルドするために必要です。
  * **[awk]**                     — Makefileのためのヘルパーツール。
  * **[patch]**                   — ソースコードを修正するためのもの。
  * **[cmake]** (>= 3.4.3)        — `libgit2`をビルドするために必要です。
  * **[pkg-config]**              — `libgit2`を正しくビルドするために必要で、特にプロキシサポートに関して。
  * **[powershell]** (>= 3.0)     — Windowsでのみ必要です。
  * **[which]**                   — ビルド依存関係を確認するために必要です。

Debian系のディストリビューション（例：Ubuntu）では、`apt-get`を使って簡単にインストールできます：

```
sudo apt-get install build-essential libatomic1 python gfortran perl wget m4 cmake pkg-config curl
```

Juliaは、次の外部ライブラリを使用しており、これらは自動的にダウンロードされ（または一部はJuliaソースリポジトリに含まれ）、最初に`make`を実行したときにソースからコンパイルされます。Juliaが使用するこれらのライブラリの特定のバージョン番号は、[`deps/$(libname).version`](https://github.com/JuliaLang/julia/blob/master/deps/)にリストされています。

  * **[LLVM]** (15.0 + [patches](https://github.com/JuliaLang/llvm-project/tree/julia-release/15.x)) — コンパイラインフラストラクチャ (see [note below](#llvm))。
  * **[FemtoLisp]**            — Juliaソースと共にパッケージ化され、コンパイラのフロントエンドを実装するために使用されます。
  * **[libuv]**  (カスタムフォーク) — ポータブルで高性能なイベントベースのI/Oライブラリ。
  * **[OpenLibm]**             — 基本的な数学関数を含むポータブルlibmライブラリ。
  * **[DSFMT]**                — 高速メルセンヌツイスタ擬似乱数生成器ライブラリ。
  * **[OpenBLAS]**             — 高速でオープン、かつメンテナンスされている [基本線形代数サブルーチン (BLAS)]
  * **[LAPACK]**               — 同時線形方程式の系を解くための線形代数ルーチンのライブラリ、線形方程式系の最小二乗解、固有値問題、および特異値問題。
  * **[MKL]** (オプション)       – OpenBLAS と LAPACK は Intel の MKL ライブラリに置き換えられる可能性があります。
  * **[SuiteSparse]**          — スパース行列のための線形代数ルーチンのライブラリ。
  * **[PCRE]**                 — Perl互換の正規表現ライブラリ。
  * **[GMP]**                  — GNU多倍精度算術ライブラリ、`BigInt`サポートに必要です。
  * **[MPFR]**                 — GNU 多倍精度浮動小数点ライブラリで、任意精度浮動小数点（`BigFloat`）サポートに必要です。
  * **[libgit2]**              — Juliaのパッケージマネージャーで使用される、Gitリンク可能ライブラリ。
  * **[curl]**                 — libcurlはダウンロードとプロキシサポートを提供します。
  * **[libssh2]**              — SSHトランスポート用のライブラリで、SSHリモートを持つパッケージのためにlibgit2によって使用されます。
  * **[OpenSSL]**              — 暗号化とトランスポート層セキュリティに使用されるライブラリで、libgit2およびlibssh2によって使用されます。
  * **[utf8proc]**             — UTF-8エンコードされたUnicode文字列を処理するためのライブラリ。
  * **[LLVM libunwind]**       — LLVMの[libunwind]のフォークで、プログラムのコールチェーンを特定するライブラリです。
  * **[ITTAPI]**               — インテルの計測およびトレース技術とジャストインタイムAPI。

[GNU make]:     https://www.gnu.org/software/make [patch]:        https://www.gnu.org/software/patch [wget]:         https://www.gnu.org/software/wget [m4]:           https://www.gnu.org/software/m4 [awk]:          https://www.gnu.org/software/gawk [gcc]:          https://gcc.gnu.org [clang]:        https://clang.llvm.org [python]:       https://www.python.org/ [gfortran]:     https://gcc.gnu.org/fortran/ [curl]:         https://curl.haxx.se [fetch]:        https://www.freebsd.org/cgi/man.cgi?fetch(1) [perl]:         https://www.perl.org [cmake]:        https://www.cmake.org [OpenLibm]:     https://github.com/JuliaLang/openlibm [DSFMT]:        https://github.com/MersenneTwister-Lab/dSFMT [OpenBLAS]:     https://github.com/xianyi/OpenBLAS [LAPACK]:       https://www.netlib.org/lapack [MKL]:          https://software.intel.com/en-us/articles/intel-mkl [SuiteSparse]:  https://people.engr.tamu.edu/davis/suitesparse.html [PCRE]:         https://www.pcre.org [LLVM]:         https://www.llvm.org [LLVM libunwind]: https://github.com/llvm/llvm-project/tree/main/libunwind [FemtoLisp]:    https://github.com/JeffBezanson/femtolisp [GMP]:          https://gmplib.org [MPFR]:         https://www.mpfr.org [libuv]:        https://github.com/JuliaLang/libuv [libgit2]:      https://libgit2.org/ [utf8proc]:     https://julialang.org/utf8proc/ [libunwind]:    https://www.nongnu.org/libunwind [libssh2]:      https://www.libssh2.org [OpenSSL]:      https://www.openssl.org/ [pkg-config]:   https://www.freedesktop.org/wiki/Software/pkg-config/ [powershell]:   https://docs.microsoft.com/en-us/powershell/scripting/wmf/overview [which]:        https://carlowood.github.io/which/ [ITTAPI]:       https://github.com/intel/ittapi

## Build dependencies

システムにこれらのパッケージの1つ以上が既にインストールされている場合、`USE_SYSTEM_...=1`を`make`に渡すか、`Make.user`に行を追加することで、Juliaがこれらのライブラリの重複をコンパイルするのを防ぐことができます。可能なフラグの完全なリストは`Make.inc`にあります。

この手順は公式にサポートされていないことに注意してください。これは、依存関係のインストールとバージョン管理に追加の変動をもたらすためであり、システムパッケージのメンテナンス担当者のみに推奨されます。ビルドシステムは、適切なパッケージがインストールされていることを確認するためのさらなるチェックを行わないため、予期しないコンパイルエラーが発生する可能性があります。

### LLVM

最も複雑な依存関係はLLVMであり、追加のパッチが上流から必要です（LLVMは後方互換性がありません）。

JuliaをLLVMと一緒にパッケージ化するには、次のいずれかをお勧めします：

  * Juliaパッケージ内にJulia専用のLLVMライブラリをバンドルすること、または
  * 配布のLLVMパッケージにパッチを追加します。

      * [Github](https://github.com/JuliaLang/llvm-project) に完全なパッチのリストが利用可能であり、`julia-release/18.x` ブランチを参照してください。
      * 唯一のJulia特有のパッチはlibの名前変更（`llvm7-symver-jlprefix.patch`）であり、これはシステムLLVMに適用すべきではありません。
      * 残りのパッチはすべて上流のバグ修正であり、上流のLLVMに寄稿されています。

未修正のLLVMまたは異なるバージョンを使用すると、エラーやパフォーマンスの低下が発生します。次のオプションを使用して、リモートGitリポジトリから異なるバージョンのLLVMをビルドできます `Make.user` ファイル:

```make
# Force source build of LLVM
USE_BINARYBUILDER_LLVM = 0
# Use Git for fetching LLVM source code
# this is either `1` to get all of them
DEPS_GIT = 1
# or a space-separated list of specific dependencies to download with git
DEPS_GIT = llvm

# Other useful options:
#URL of the Git repository you want to obtain LLVM from:
#  LLVM_GIT_URL = ...
#Name of the alternate branch to clone from git
#  LLVM_BRANCH = julia-16.0.6-0
#SHA hash of the alternate commit to check out automatically
#  LLVM_SHA1 = $(LLVM_BRANCH)
#List of LLVM targets to build. It is strongly recommended to keep at least all the
#default targets listed in `deps/llvm.mk`, even if you don't necessarily need all of them.
#  LLVM_TARGETS = ...
#Use ccache for faster recompilation in case you need to restart a build.
#  USECCACHE = 1
#  CMAKE_GENERATOR=Ninja
#  LLVM_ASSERTIONS=1
#  LLVM_DEBUG=Symbols
```

さまざまなビルドフェーズは特定のファイルによって制御されています：

  * `deps/llvm.version` : 新しいバージョンをチェックアウトするためにタッチまたは変更し、`make get-llvm check-llvm`
  * `deps/srccache/llvm/source-extracted` : `make extract-llvm` の結果
  * `deps/llvm/build_Release*/build-configured` : `make configure-llvm` の結果
  * `deps/llvm/build_Release*/build-configured` : `make compile-llvm` の結果
  * `usr-staging/llvm/build_Release*.tgz` : `make stage-llvm` の結果（`make reinstall-llvm` で再生成）
  * `usr/manifest/llvm` : `make install-llvm` の結果（`make uninstall-llvm` で再生成）
  * `make version-check-llvm` : ユーザーにローカルの変更がある場合に警告するために毎回実行されます。

Juliaは新しいLLVMバージョンでビルドすることができますが、これに対するサポートは実験的なものであり、パッケージングには適していないと見なされるべきです。

### libuv

Juliaはlibuvのカスタムフォークを使用しています。これは小さな依存関係であり、Juliaと同じパッケージに安全にバンドルでき、システムライブラリと競合することはありません。Juliaのビルドはシステムlibuvを使用しようとするべきではありません。

### BLAS and LAPACK

高性能の数値言語として、JuliaはOpenBLASやATLASのようなマルチスレッドBLASおよびLAPACKにリンクされるべきであり、これにより一部のシステムでデフォルトとなる可能性のある参照`libblas`実装よりもはるかに優れたパフォーマンスが提供されます。

## Source distributions of releases

各プレリリースおよびリリースのJuliaには、「フル」ソース配布と「ライト」ソース配布があります。

フルソースディストリビューションには、Juliaのソースコードとすべての依存関係が含まれており、インターネット接続なしでソースからビルドできます。ライトソースディストリビューションには、依存関係のソースコードは含まれていません。

例えば、`julia-1.0.0.tar.gz` は Julia の `v1.0.0` リリースの軽量ソース配布であり、`julia-1.0.0-full.tar.gz` は完全なソース配布です。

## Building Julia from source with a Git checkout of a stdlib

Juliaをソースからビルドする必要があり、標準ライブラリのGitチェックアウトを使用する場合は、Juliaをビルドする際に`make DEPS_GIT=NAME_OF_STDLIB`を使用してください。

たとえば、PkgのGitチェックアウトを使用してJuliaをソースからビルドする必要がある場合は、Juliaをビルドする際に`make DEPS_GIT=Pkg`を使用してください。`Pkg`リポジトリは`stdlib/Pkg`にあり、最初はデタッチされた`HEAD`で作成されます。既存のJuliaリポジトリからこれを行う場合は、事前に`make clean`を実行する必要があるかもしれません。

もし複数の標準ライブラリのGitチェックアウトを使用してJuliaをソースからビルドする必要がある場合、`DEPS_GIT`は標準ライブラリ名のスペース区切りリストである必要があります。たとえば、Pkg、Tar、およびDownloadsのGitチェックアウトを使用してJuliaをソースからビルドする必要がある場合、Juliaをビルドする際に`make DEPS_GIT='Pkg Tar Downloads'`を使用してください。

## Building an "assert build" of Julia

"アサートビルド"のJuliaは、`FORCE_ASSERTIONS=1`と`LLVM_ASSERTIONS=1`の両方でビルドされたものです。アサートビルドを作成するには、`Make.user`ファイルに以下の2つの変数を定義します：

```
FORCE_ASSERTIONS=1
LLVM_ASSERTIONS=1
```

アサートビルドのJuliaは、通常の（非アサート）ビルドよりも遅くなることに注意してください。

## Building 32-bit Julia on a 64-bit machine

時折、32ビットアーキテクチャに特有のバグが発生することがあります。このような場合、ローカルマシンで問題をデバッグできることが役立ちます。ほとんどの現代の64ビットシステムは、32ビット用にビルドされたプログラムを実行することをサポートしているため、ソースからJuliaを再コンパイルする必要がない場合（例えば、Cコードに触れることなく32ビットのJuliaの動作を主に調査する必要がある場合）、[official downloads page](https://julialang.org/downloads/)から取得できる32ビットビルドのJuliaを使用できる可能性があります。しかし、ソースからJuliaを再コンパイルする必要がある場合の1つの選択肢は、32ビットシステムのDockerコンテナを使用することです。少なくとも今のところ、[ubuntu 32-bit docker images](https://hub.docker.com/r/i386/ubuntu)を使用して32ビット版のJuliaをビルドするのは比較的簡単です。簡単に言うと、`docker`をセットアップした後、必要な手順は次のとおりです：

```sh
$ docker pull i386/ubuntu
$ docker run --platform i386 -i -t i386/ubuntu /bin/bash
```

この時点で、あなたは32ビットマシンのコンソールにいるはずです（`uname`がホストアーキテクチャを報告するため、64ビットと表示されることがありますが、これはJuliaのビルドには影響しません）。パッケージを追加したり、コードをコンパイルしたりできます。`exit`すると、すべての変更が失われるため、単一のセッションで分析を終えるか、環境を設定するために使用できるコピー/ペースト可能なスクリプトを用意してください。

この時点から、あなたは次のことをすべきです。

```sh
# apt update
```

（`sudo`はインストールされていませんが、`root`として実行しているため、すべてのコマンドから`sudo`を省略できます。）

次に、すべての [build dependencies](#required-build-tools-and-external-libraries)、お好みのコンソールベースのエディタ、`git`、および必要なその他のもの（例：`gdb`、`rr` など）を追加します。作業するディレクトリを選択し、`git clone` で Julia をクローンし、デバッグしたいブランチをチェックアウトし、通常通りに Julia をビルドします。

## Update the version number of a dependency

ビルドには2つのタイプがあります。

1. ソースコードからすべてをビルドします（`deps/` と `src/`）。  （`Make.user` に `USE_BINARYBUILDER=0` を追加してください。詳細は [Building Julia](#building-julia) を参照）
2. ソースからビルドする（`src/`）プリコンパイルされた依存関係付き（デフォルト）

`deps/`内の依存関係のバージョン番号を更新したい場合は、次のチェックリストを使用することをお勧めします：

```md
### Check list

Version numbers:
- [ ] `deps/$(libname).version`: `LIBNAME_VER`, `LIBNAME_BRANCH`, `LIBNAME_SHA1` and `LIBNAME_JLL_VER`
- [ ] `stdlib/$(LIBNAME_JLL_NAME)_jll/Project.toml`: `version`

Checksum:
- [ ] `deps/checksums/$(libname)`
- [ ] `deps/checksums/$(LIBNAME_JLL_NAME)-*/`: `md5` and `sha512`

Patches:
- [ ] `deps/$(libname).mk`
- [ ] `deps/patches/$(libname)-*.patch`
```

注意:

  * 特定の依存関係に対して、チェックリストのいくつかの項目が存在しない場合があります。
  * チェックサムファイルは、**サフィックスのない単一のファイル**であるか、**2つのファイルを含むフォルダー**である可能性があります。

### Example: `OpenLibm`

1. `deps/openlibm.version`のバージョン番号を更新してください。

      * `OPENLIBM_VER := 0.X.Y`
      * `OPENLIBM_BRANCH = v0.X.Y`
      * `OPENLIBM_SHA1 = new-sha1-hash`
2. `stdlib/OpenLibm_jll/Project.toml` のバージョン番号を更新してください。

      * `version = "0.X.Y+0"`
3. `deps/checksums/openlibm`のチェックサムを更新します。

      * `make -f contrib/refresh_checksums.mk openlibm`
4. `deps/patches/openlibm-*.patch` ファイルが存在するか確認してください。

      * パッチが存在しない場合は、スキップしてください。
      * パッチが存在する場合は、それらが新しいバージョンにマージされているかどうかを確認し、削除する必要があるかを確認してください。パッチを削除する際は、対応するMakefileファイル（`deps/openlibm.mk`）を修正することを忘れないでください。
