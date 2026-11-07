# Building Julia (Detailed)

## Downloading the Julia source code

ファイアウォールの内側にいる場合は、`https` プロトコルではなく、`git` プロトコルを使用する必要がある場合があります。

```sh
git config --global url."https://".insteadOf git://
```

また、適切なプロキシ設定を使用するようシステムを設定してください。たとえば、`https_proxy` および `http_proxy` 変数を設定します。

## Building Julia

初回のコンパイル時には、ビルドによって事前ビルド済みの [external dependencies](#Required-Build-Tools-and-External-Libraries) が自動的にダウンロードされます。すべての依存関係を自分でビルドする場合、またはビルド中にネットワークへアクセスできないシステムでビルドする場合は、`Make.user` に次の内容を追加してください。

```
USE_BINARYBUILDER=0
```

すべての依存関係をビルドする場合、Julia のビルドには 5 GiB のディスク容量と、約 4 GiB の仮想メモリが必要です。

並列ビルドを行うには、`make -j N` を使用し、同時に実行するプロセスの最大数を指定します。ビルドのデフォルト設定が適さず、特定の make パラメーターを設定する必要がある場合は、それらを `Make.user` に保存し、そのファイルを Julia ソースのルートに置くことができます。ビルドでは `Make.user` の有無が自動的に確認され、存在する場合は使用されます。

コマンドラインで `make O=<build-directory> configure` を指定すると、Julia をソースツリー外でビルドできます。指定したディレクトリに、Julia のビルドに必要な Makefile 一式を含むディレクトリ構造が作成されます。このビルドでは、Julia のソースファイルと `deps/srccache` が共有されます。ソースツリー外の各ビルドディレクトリには、トップレベルフォルダーにある共通の `Make.user` ファイルを上書きするための `Make.user` ファイルを個別に置くことができます。必要に応じて `Make.user` ファイルを変更した後、次のコマンドでビルドします。`make -C <build-directory>`

すべて正常に動作すれば、ビルドディレクトリに julia 実行ファイルへのシンボリックリンクが作成され、次のように実行できます。

```sh
./julia
```

実際の実行ファイルは `<build-directory>/usr/bin` にあります。実行すると、Julia のバナーと、式を入力して評価できる対話型プロンプトが表示されます。（ライブラリに関するエラーは、PATH 内に古い互換性のないライブラリが残っていることが原因の場合があります。その場合は、`julia` ディレクトリを PATH の前方に移動してみてください。）なお、上記の手順の大半は Unix 系システムを対象としています。

どこからでも julia を実行できるようにするには、次のいずれかを行います。

  * エイリアスを追加する（`bash` に記述します。例：`echo "alias julia='<build-directory>/usr/bin/julia'" >> ~/.bashrc && source ~/.bashrc`）。
  * `<build-directory>/usr/bin` ディレクトリにある `julia` 実行ファイルへのシンボリックリンクを、`/usr/local/bin`（または PATH に含まれる適切なディレクトリ）に追加する。
  * このシェルセッションで使用する実行ファイルのパスに `julia` ディレクトリを追加する（`bash` の場合は `export PATH="$(pwd):$PATH"`、`csh` または `tcsh` の場合は次のとおりです。

`set path= ( $path $cwd )` ）、または

  * `julia` ディレクトリを実行ファイルのパスに恒久的に追加する（例：`.bash_profile`）。
  * `prefix=/path/to/install/folder` を `Make.user` に書き込み、その後 `make install` を実行する。このフォルダーにすでに Julia がインストールされている場合は、`make install` を実行する前に削除してください。

Julia のビルドを制御するオプションの一部は、`Make.inc` ファイルの冒頭に記載されています。ただし、この目的でそのファイルを編集してはいけません。代わりに `Make.user` を使用してください。

Julia の Makefile には、変数の値を表示するための便利な自動ルール `print-<VARNAME>` が定義されています。値を表示する変数名を `<VARNAME>` に指定します。たとえば、次のとおりです。

```console
$ make print-JULIA_PRECOMPILE
JULIA_PRECOMPILE=1
```

これらのルールはデバッグに役立ちます。

これで、次のように Julia を実行できるはずです。

```
julia
```

Linux、macOS、または Windows 向けに配布する Julia パッケージをビルドする場合は、[distributing.md](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/distributing.md) にある詳細な注意事項を参照してください。

## Updating an existing source tree

以前に `git clone` を使って `julia` をダウンロードしている場合は、最初からやり直す代わりに、`git pull` を使って既存のソースツリーを更新できます。

```sh
cd julia
git pull && make
```

上流の更新と競合する変更をソースツリーに加えていない場合、これらのコマンドによってビルドが実行され、最新バージョンに更新されます。

## General troubleshooting

1. 時間の経過とともにベースライブラリに変更が蓄積し、システムイメージのビルド時にブートストラップ処理が失敗することがあります。その場合、次のようなエラーが発生してビルドに失敗することがあります。

   ```sh
    *** This error is usually fixed by running 'make clean'. If the error persists, try 'make cleanall' ***
   ```

   説明にあるとおり、通常は `make clean && make` を実行すれば十分です。場合によっては、より強力なクリーンアップを行う `make cleanall` が必要になります。
2. 外部依存関係の新しいバージョンが導入されると、古いバージョンを使った既存のビルドと競合することがあります。

   a. 依存関係の既存のビルドを消去するための専用の `make` ターゲットが用意されています。たとえば、`make -C deps clean-llvm` を実行すると、`llvm` の既存のビルドが削除され、次回 `make` を呼び出したときに、ダウンロード済みのソース配布物から `llvm` が再ビルドされます。`make -C deps distclean-llvm` はさらに強力な消去を行い、ダウンロード済みのソース配布物も削除します。そのため、次回 `make` を呼び出すと、ソース配布物が新たにダウンロードされ、新しいパッチが適用されます。

   b. `julia` とそのすべての依存関係の既存のバイナリを削除するには、ソースツリー内の `./usr` ディレクトリを削除してください。
3. macOS を最近アップデートした場合は、必ず `xcode-select --install` を実行してコマンドラインツールを更新してください。そうしないと、`ld: library not found for -lcrt1.10.6.o` など、ヘッダーやライブラリが見つからないというエラーが発生することがあります。
4. ソースディレクトリを移動した場合、`CMake Error: The current CMakeCache.txt directory ... is different than the directory ... where     CMakeCache.txt was created.` などのエラーが発生することがあります。その場合は、`deps` にある問題の依存関係を削除してください。
5. 極端な場合は、ソースツリーを初期状態に戻す必要があるかもしれません。次の git コマンドが役立ちます。

   ```sh
    git reset --hard #Forcibly remove any changes to any files under version control
    git clean -x -f -d #Forcibly remove any file or directory not under version control
   ```

   *作業内容を失わないよう、実行前にこれらのコマンドの動作を理解してください。`git` では、これらの変更を元に戻せません。*

## Platform-Specific Notes

各種オペレーティングシステムに関する注意事項：

  * [Linux](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/linux.md)
  * [macOS](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/macos.md)
  * [Windows](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/windows.md)
  * [FreeBSD](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/freebsd.md)

各種アーキテクチャに関する注意事項：

  * [ARM](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/arm.md)
  * [RISC-V](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/build/riscv.md)

## Required Build Tools and External Libraries

Julia のビルドには、次のソフトウェアがインストールされている必要があります。

  * **[GNU make](https://www.gnu.org/software/make)** — 依存関係のビルドに使用。
  * **[gcc & g++](https://gcc.gnu.org)**（>= 7.1）または **[Clang](https://clang.llvm.org)**（>= 5.0、Apple Clang の場合は >= 9.3）— C、C++ のコンパイルとリンクに使用。
  * **[libatomic](https://gcc.gnu.org)** — **[gcc]** に含まれており、アトミック操作のサポートに必要。
  * **[python](https://www.python.org/)**（>=2.7）— LLVM のビルドに必要。
  * **[gfortran](https://gcc.gnu.org/fortran/)** — Fortran ライブラリのコンパイルとリンクに使用。
  * **[perl](https://www.perl.org)** — ライブラリのヘッダーファイルの前処理に使用。
  * **[wget](https://www.gnu.org/software/wget)**、**[curl](https://curl.se)**、または **[fetch](https://www.freebsd.org/cgi/man.cgi?fetch(1))**（FreeBSD）— 外部ライブラリの自動ダウンロードに使用。
  * **[m4](https://www.gnu.org/software/m4)** — GMP のビルドに必要。
  * **[awk](https://www.gnu.org/software/gawk)** — Makefile 用の補助ツール。
  * **[patch](https://www.gnu.org/software/patch)** — ソースコードの変更に使用。
  * **[cmake](https://www.cmake.org)**（>= 3.4.3）— `libgit2` のビルドに必要。
  * **[pkg-config](https://www.freedesktop.org/wiki/Software/pkg-config/)** — `libgit2` を正しくビルドするために必要。特にプロキシのサポートに使用。
  * **[powershell](https://docs.microsoft.com/en-us/powershell/scripting/wmf/overview)**（>= 3.0）— Windows でのみ必要。
  * **[which](https://carlowood.github.io/which/)** — ビルド依存関係の確認に必要。

Debian 系ディストリビューション（Ubuntu など）では、`apt-get` を使って簡単にインストールできます。

```
sudo apt-get install build-essential libatomic1 python gfortran perl wget m4 cmake pkg-config curl
```

Red Hat 系ディストリビューション（Fedora、CentOS など）では、`yum` を使ってインストールできます。

```
sudo dnf install gcc gcc-c++ gcc-gfortran python3 perl wget m4 cmake pkgconfig curl
```

Julia は次の外部ライブラリを使用します。これらは自動的にダウンロードされる（または一部は Julia のソースリポジトリに含まれる）もので、`make` を初めて実行したときにソースからコンパイルされます。Julia が使用する各ライブラリのバージョンは、[`deps/$(libname).version`](https://github.com/JuliaLang/julia/blob/master/deps/) に記載されています。

  * **[LLVM](https://www.llvm.org)**（15.0 + [patches](https://github.com/JuliaLang/llvm-project/tree/julia-release/15.x)）— コンパイラ基盤（[note below](#llvm) を参照）。
  * **[FemtoLisp](https://github.com/JeffBezanson/femtolisp)** — Julia のソースに含まれ、コンパイラのフロントエンドの実装に使用。
  * **[libuv](https://github.com/JuliaLang/libuv)**（カスタムフォーク）— 移植性に優れた高性能のイベント駆動型 I/O ライブラリ。
  * **[OpenLibm](https://github.com/JuliaLang/openlibm)** — 基本的な数学関数を含む、移植性に優れた libm ライブラリ。
  * **[DSFMT](https://github.com/MersenneTwister-Lab/dSFMT)** — 高速な Mersenne Twister 疑似乱数生成ライブラリ。
  * **[OpenBLAS](https://github.com/xianyi/OpenBLAS)** — 高速でオープンな、保守が継続されている [基本線形代数サブプログラム（BLAS）]
  * **[LAPACK](https://www.netlib.org/lapack)** — 連立一次方程式の解法、最小二乗解、固有値問題、特異値問題を扱う線形代数ルーチンのライブラリ。
  * **[MKL](https://software.intel.com/en-us/articles/intel-mkl)**（任意）— OpenBLAS と LAPACK は Intel の MKL ライブラリに置き換えることができます。
  * **[SuiteSparse](https://people.engr.tamu.edu/davis/suitesparse.html)** — 疎行列用の線形代数ルーチンライブラリ。
  * **[PCRE](https://www.pcre.org)** — Perl 互換の正規表現ライブラリ。
  * **[GMP](https://gmplib.org)** — GNU 多倍長演算ライブラリ。`BigInt` のサポートに必要。
  * **[MPFR](https://www.mpfr.org)** — GNU 多倍長浮動小数点ライブラリ。任意精度浮動小数点数（`BigFloat`）のサポートに必要。
  * **[libgit2](https://libgit2.org/)** — Julia のパッケージマネージャーが使用する、Git のリンク可能ライブラリ。
  * **[curl](https://curl.se)** — libcurl はダウンロードとプロキシをサポートします。
  * **[libssh2](https://www.libssh2.org)** — SSH トランスポート用ライブラリ。SSH リモートを使うパッケージで libgit2 が使用。
  * **[OpenSSL](https://www.openssl.org/)** — 暗号化とトランスポート層セキュリティ用ライブラリ。libgit2 と libssh2 が使用。
  * **[utf8proc](https://julialang.org/utf8proc/)** — UTF-8 エンコードされた Unicode 文字列を処理するライブラリ。
  * **[LLVM libunwind](https://www.nongnu.org/libunwind)** — LLVM の libunwind フォーク。プログラムの呼び出しチェーンを特定するライブラリ。
  * **[ITTAPI](https://github.com/intel/ittapi)** — Intel の計測・トレース技術および Just-In-Time API。

## Build dependencies

これらのパッケージがすでにシステムにインストールされている場合は、`USE_SYSTEM_...=1` を `make` に渡すか、`Make.user` に追加することで、Julia がこれらのライブラリを重複してコンパイルするのを防げます。指定可能なフラグの一覧は `Make.inc` にあります。

この手順は公式にはサポートされていない点に注意してください。依存関係のインストールやバージョン管理にばらつきが生じるためであり、システムパッケージのメンテナーに限って推奨されます。ビルドシステムは必要なパッケージが適切にインストールされているか、それ以上確認しないため、予期しないコンパイルエラーが発生する可能性があります。

### LLVM

最も複雑な依存関係は LLVM です。LLVM は後方互換性がないため、上流から追加のパッチを適用する必要があります。

LLVM とともに Julia をパッケージ化する場合は、次のいずれかを推奨します。

  * Julia パッケージ内に Julia 専用の LLVM ライブラリを同梱する。
  * ディストリビューションの LLVM パッケージにパッチを追加する。

      * パッチの全一覧は [Github](https://github.com/JuliaLang/llvm-project) にあります。`julia-release/18.x` ブランチを参照してください。
      * 残りのパッチはすべて上流のバグ修正であり、上流の LLVM に取り込まれています。

パッチ未適用の LLVM や異なるバージョンの LLVM を使用すると、エラーが発生したり、パフォーマンスが低下したりします。`Make.user` ファイルで次のオプションを指定すると、リモートの Git リポジトリから別のバージョンの LLVM をビルドできます。

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

各ビルド段階は、次のファイルによって制御されます。

  * `deps/llvm.version`：新しいバージョンをチェックアウトするために、タイムスタンプを更新するか内容を変更する。`make get-llvm check-llvm`
  * `deps/srccache/llvm/source-extracted`：`make extract-llvm` の結果
  * `deps/llvm/build_Release*/build-configured`：`make configure-llvm` の結果
  * `deps/llvm/build_Release*/build-configured`：`make compile-llvm` の結果
  * `usr-staging/llvm/build_Release*.tgz`：`make stage-llvm` の結果（`make reinstall-llvm` で再生成）
  * `usr/manifest/llvm`：`make install-llvm` の結果（`make uninstall-llvm` で再生成）
  * `make version-check-llvm`：ローカルで変更が加えられている場合にユーザーへ警告するため、毎回実行

Julia はより新しいバージョンの LLVM でもビルドできますが、そのサポートは実験的なものと見なすべきであり、パッケージ化には適していません。

### libuv

Julia は libuv のカスタムフォークを使用します。依存関係としては小規模で、Julia と同じパッケージに安全に同梱でき、システムライブラリと競合することもありません。Julia のビルドでは、システムの libuv を使用しないでください。

### BLAS and LAPACK

高性能な数値計算言語である Julia は、OpenBLAS や ATLAS などのマルチスレッド対応 BLAS および LAPACK とリンクする必要があります。これらは、一部のシステムでデフォルトになっている可能性のある参照実装 `libblas` よりも、はるかに優れたパフォーマンスを発揮します。

## Source distributions of releases

Julia の各プレリリース版およびリリース版には、「完全版」と「軽量版」のソース配布物があります。

完全版のソース配布物には、Julia とすべての依存関係のソースコードが含まれているため、インターネットに接続せずにソースからビルドできます。軽量版のソース配布物には、依存関係のソースコードは含まれていません。

たとえば、`julia-1.0.0.tar.gz` は Julia の `v1.0.0` リリースの軽量版ソース配布物で、`julia-1.0.0-full.tar.gz` は完全版のソース配布物です。

## Building Julia from source with a Git checkout of a stdlib

stdlib の Git チェックアウトを使って Julia をソースからビルドする必要がある場合は、ビルド時に `make DEPS_GIT=NAME_OF_STDLIB` を使用してください。

たとえば、Pkg の Git チェックアウトを使って Julia をソースからビルドする場合は、ビルド時に `make DEPS_GIT=Pkg` を使用してください。`Pkg` リポジトリは `stdlib/Pkg` にあり、最初は detached `HEAD` で作成されます。既存の Julia リポジトリで作業している場合は、事前に `make clean` が必要になることがあります。

複数の stdlib の Git チェックアウトを使って Julia をソースからビルドする場合、`DEPS_GIT` には stdlib 名をスペース区切りで指定します。たとえば、Pkg、Tar、Downloads の Git チェックアウトを使って Julia をソースからビルドする場合は、ビルド時に `make DEPS_GIT='Pkg Tar Downloads'` を使用してください。

## Building an "assert build" of Julia

Julia の「assert ビルド」とは、`FORCE_ASSERTIONS=1` と `LLVM_ASSERTIONS=1` の両方を指定してビルドしたものです。assert ビルドを行うには、`Make.user` ファイルで次の両方の変数を定義します。

```
FORCE_ASSERTIONS=1
LLVM_ASSERTIONS=1
```

assert ビルドの Julia は、通常の（assert なしの）ビルドよりも遅くなることに注意してください。

## Building a debug build of Julia

`make debug` を使うと、Julia の完全なデバッグビルドを作成できます。これは `libjulia` のデバッグ版をビルドしてコンパイラのブートストラップに使用した後、デバッグシンボルを有効にしたシステムイメージを作成します。15 分以上かかる場合があります。

リリースビルドからブートストラップすると、多少の違いが生じる可能性はありますが、デバッグビルドをより短時間で作成できます。

```sh
$ make julia-src-release julia-sysbase-release
$ make julia-sysimg-debug CROSS_BOOTSTRAP_JULIA=$PWD/usr/bin/julia CROSS_BOOTSTRAP_SYSBASE=$PWD/usr/lib/julia/sysbase.so
```

## Building 32-bit Julia on a 64-bit machine

32 ビットアーキテクチャ固有のバグが発生することがあり、その場合はローカルマシンで問題をデバッグできると便利です。現在の 64 ビットシステムの多くは 32 ビット向けにビルドされたプログラムを実行できるため、Julia をソースから再コンパイルする必要がない場合（たとえば、C コードに手を加えずに 32 ビット版 Julia の動作を調べるだけの場合）は、[official downloads page](https://julialang.org/downloads/) から入手できる、お使いのシステム向けの 32 ビット版 Julia を利用できるでしょう。一方、Julia をソースから再コンパイルする必要がある場合は、32 ビットシステムの Docker コンテナを使う方法があります。少なくとも現時点では、[ubuntu 32-bit docker images](https://hub.docker.com/r/i386/ubuntu) を使えば、32 ビット版 Julia を比較的簡単にビルドできます。概要として、ここで `docker` を設定した後、次の手順を実行します。

```sh
$ docker pull i386/ubuntu
$ docker run --platform i386 -i -t i386/ubuntu /bin/bash
```

この時点で、32 ビットマシンのコンソールが表示されているはずです（`uname` はホストのアーキテクチャを報告するため、64 ビットと表示されますが、Julia のビルドには影響しません）。パッケージを追加したり、コードをコンパイルしたりできます。`exit` を実行すると変更内容はすべて失われるため、分析を1回のセッションで終えるか、環境を設定するためのコピー＆ペースト可能なスクリプトを用意してください。

ここからは、次の手順を実行します。

```sh
# apt update
```

（`sudo` はインストールされていませんが、`root` として実行しているため必要ありません。したがって、すべてのコマンドから `sudo` を省略できます。）

次に、[build dependencies](#required-build-tools-and-external-libraries)、任意のコンソールベースのエディター、`git`、およびその他必要なもの（例：`gdb`、`rr` など）をすべて追加します。作業用ディレクトリを選び、そこで `git clone` を使って Julia を取得し、デバッグするブランチをチェックアウトして、通常どおり Julia をビルドしてください。

## Update the version number of a dependency

ビルド方法は2種類あります。

1. すべて（`deps/` と `src/`）をソースコードからビルドする。（`USE_BINARYBUILDER=0` を `Make.user` に追加してください。[Building Julia](#building-julia) を参照。）
2. 依存関係は事前コンパイル済みのものを使い、`src/` をソースからビルドする（デフォルト）。

`deps/` で依存関係のバージョンを更新する場合は、次のチェックリストを参考にしてください。

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

注：

  * 依存関係によっては、チェックリストの項目が存在しない場合があります。
  * チェックサムファイルは、拡張子のない**単一のファイル**の場合と、2つのファイルを含む**フォルダー**の場合があります。

### Example: `OpenLibm`

1. `deps/openlibm.version` のバージョン番号を更新する。

     * `OPENLIBM_VER := 0.X.Y`
     * `OPENLIBM_BRANCH = v0.X.Y`
     * `OPENLIBM_SHA1 = new-sha1-hash`
2. `stdlib/OpenLibm_jll/Project.toml` のバージョン番号を更新する。

     * `version = "0.X.Y+0"`
3. `deps/checksums/openlibm` のチェックサムを更新する。

     * `make -f contrib/refresh_checksums.mk openlibm`
4. パッチファイル `deps/patches/openlibm-*.patch` が存在するか確認する。

     * パッチが存在しない場合は、この手順を省略する。
     * パッチが存在する場合は、新しいバージョンに取り込まれていて削除が必要かどうかを確認する。パッチを削除する際は、対応する Makefile（`deps/openlibm.mk`）も変更してください。
