# Windows

このファイルでは、Windows 上で Julia をインストールまたはビルドし、使用する方法を説明します。

Julia に関する一般的な情報については、[main README](https://github.com/JuliaLang/julia/blob/master/README.md) または [documentation](https://docs.julialang.org) を参照してください。

## General Information for Windows

Julia の実行には、最新のターミナルアプリケーションを使用することを強くお勧めします。特に、[Microsoft Store](https://aka.ms/terminal) からインストールできる Windows Terminal を推奨します。

### Line endings

Julia はファイルを常にバイナリモードで扱います。他の多くの Windows プログラムとは異なり、`\n` をファイルに書き込むと、ファイルには別のビットパターンではなく `\n` が書き込まれます。これは他のオペレーティングシステムの動作と同じです。Git for Windows をインストールしている場合は、必須ではありませんが、システムの Git も同じ規則に従うよう設定することをお勧めします。

```sh
git config --global core.eol lf
git config --global core.autocrlf input
```

または、`%USERPROFILE%\.gitconfig` を編集し、次の行を追加または変更してください。

```
[core]
    eol = lf
    autocrlf = input
```

## Binary distribution

Windows でのバイナリ配布版のインストールに関する注意事項は、[https://julialang.org/downloads/platform/#windows](https://julialang.org/downloads/platform/#windows) の手順を参照してください。ただし、すべてのプラットフォームで、バイナリを手動でインストールするよりも [using `juliaup`](https://julialang.org/install/) を使用することをお勧めします。

## Source distribution

### Cygwin-to-MinGW cross-compiling

Windows で Julia をソースからコンパイルする場合は、Cygwin のパッケージマネージャーで提供されている MinGW-w64 コンパイラを使い、[Cygwin](https://www.cygwin.com) からクロスコンパイルする方法をお勧めします。

1. [32 bit](https://cygwin.com/setup-x86.exe) または [64 bit](https://cygwin.com/setup-x86_64.exe) 用の Cygwin セットアップをダウンロードして実行します。32 ビット版と 64 ビット版のどちらの Cygwin からでも、32 ビット版と 64 ビット版のどちらの Julia もコンパイルできます。64 ビット版 Cygwin はパッケージの種類がやや少ないものの、より新しいバージョンが提供されていることがよくあります。

   *上級者向け*: 次のコマンドを実行すると、手順 2～4 を省略できます。

   ```sh
   setup-x86_64.exe -s <url> -q -P cmake,gcc-g++=12.5.0-1,git,make,patch,curl,m4,python3,p7zip,mingw64-i686-gcc-g++=12.5.0-1,mingw64-i686-gcc-fortran=12.5.0-1,mingw64-i686-gcc-core=12.5.0-1,mingw64-i686-headers=12.0.0-1,mingw64-i686-runtime=12.0.0-1,mingw64-i686-winpthreads=12.0.0-1,mingw64-x86_64-gcc-g++=12.5.0-1,mingw64-x86_64-gcc-fortran=12.5.0-1,mingw64-x86_64-gcc-core=12.5.0-1,mingw64-x86_64-headers=12.0.0-1,mingw64-x86_64-runtime=12.0.0-1,mingw64-x86_64-winpthreads=12.0.0-1
   ```

   `<url>` は [https://cygwin.com/mirrors.html](https://cygwin.com/mirrors.html) にあるサイトに置き換えるか、先にセットアップを手動で実行してミラーを選択してください。
2. インストール先と、ダウンロード元のミラーを選択します。
3. *Select Packages* の手順で、次のパッケージを選択します。

   1. *Devel* カテゴリから: `cmake`、`gcc-g++`、`git`、`make`、`patch`
   2. *Net* カテゴリから: `curl`
   3. *Interpreters*（または *Python*）カテゴリから: `m4`、`python3`
   4. *Archive* カテゴリから: `p7zip`
   5. 32 ビット版 Julia の場合は、さらに *Devel* カテゴリから: `mingw64-i686-gcc-g++`、`mingw64-i686-gcc-fortran`、`mingw64-i686-gcc-core`（バージョン "12.5.0-1"）、`mingw64-i686-headers`、`mingw64-i686-runtime`、`mingw64-i686-winpthreads`（バージョン "12.0.0-1"）
   6. 64 ビット版 Julia の場合は、さらに *Devel* カテゴリから: `mingw64-x86_64-gcc-g++`、`mingw64-x86_64-gcc-fortran`、`mingw64-x86_64-gcc-core`（バージョン "12.5.0-1"）、`mingw64-x86_64-headers`、`mingw64-x86_64-runtime`、`mingw64-x86_64-winpthreads`（バージョン "12.0.0-1"）
4. Cygwin のインストールが完了したら、インストールされたショートカット *'Cygwin Terminal'* または *'Cygwin64 Terminal'* のうち、使用する版に対応するものから起動します。
5. Julia とその依存関係をソースからビルドします。

   1. Julia のソースを取得します。

      ```sh
      git clone https://github.com/JuliaLang/julia.git
      cd julia
      ```

      ヒント: git で `error: cannot fork() for fetch-pack: Resource temporarily unavailable` が発生した場合は、`~/.bashrc` に `alias git="env PATH=/usr/bin git"` を追加し、Cygwin を再起動してください。
   2. MinGW-w64 によるクロスコンパイルを指定するため、`Make.user` 内の `XC_HOST` 変数を設定します。

      ```sh
      echo 'XC_HOST = i686-w64-mingw32' > Make.user     # for 32 bit Julia
      # or
      echo 'XC_HOST = x86_64-w64-mingw32' > Make.user   # for 64 bit Julia
      ```
   3. ビルドを開始します。

      ```sh
      make -j 4       # Adjust the number of threads (4) to match your build environment.
      make -j 4 debug # This builds julia-debug.exe
      ```
6. Julia の実行ファイルを直接使用して Julia を実行します。

   ```sh
   usr/bin/julia.exe
   usr/bin/julia-debug.exe
   ```

!!! note "便利なヒント: 両方をビルド！"
    ```sh
    make O=julia-win32 configure
    make O=julia-win64 configure
    echo 'XC_HOST = i686-w64-mingw32' > julia-win32/Make.user
    echo 'XC_HOST = x86_64-w64-mingw32' > julia-win64/Make.user
    echo 'ifeq ($(BUILDROOT),$(JULIAHOME))
            $(error "in-tree build disabled")
          endif' >> Make.user
    make -C julia-win32  # build for Windows x86 in julia-win32 folder
    make -C julia-win64  # build for Windows x86-64 in julia-win64 folder
    ```


### Compiling with MinGW/MSYS2

[MSYS2](https://www.msys2.org/) は、Windows 向けのソフトウェアディストリビューションおよびビルド環境です。

注意: MSYS2 には、Windows 7 以降の **64 ビット版** Windows が必要です。

1. MSYS2 をインストールして設定します。

   1. [64-bit](https://github.com/msys2/msys2-installer/releases/latest) ディストリビューションの最新のインストーラーをダウンロードして実行します。インストーラーの名前は `msys2-x86_64-yyyymmdd.exe` のような形式です。
   2. MSYS2 シェルを開きます。パッケージデータベースと基本パッケージを更新します。

      ```
      pacman -Syu
      ```
   3. MSYS2 を終了して再起動します。残りの基本パッケージを更新します。

      ```
      pacman -Syu
      ```
   4. 続いて、Julia のビルドに必要なツールをインストールします。

      ```
      pacman -S diffutils git m4 make patch tar p7zip curl python
      ```

      64 ビット版 Julia の場合は、x86_64 版をインストールします。

      ```
      pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-cmake mingw-w64-x86_64-clang
      ```

      32 ビット版 Julia の場合は、i686 版をインストールします。

      ```
      pacman -S mingw-w64-i686-gcc mingw-w64-i686-cmake mingw-w64-i686-clang
      ```
   5. MSYS2 の設定は完了です。ここで `exit` を実行して MSYS2 シェルを終了します。
2. ビルド済みの依存関係を使用して、Julia とその依存関係をビルドします。

   1. 新しい [**MINGW64/MINGW32 shell**](https://www.msys2.org/docs/environments/#overview) を開きます。現在、mingw32 と mingw64 を同時に使用することはできないため、x86_64 版と i686 版の両方をビルドする場合は、それぞれの環境で個別にビルドする必要があります。
   2. Julia のソースをクローンします。

      ```sh
      git clone https://github.com/JuliaLang/julia.git
      cd julia
      ```
   3. clang を使用する場合（現在、LLVM をソースからビルドする場合には必須）は、Make.user に次の内容を記述します。

   `CC=/mingw64/bin/clang   CXX=/mingw64/bin/clang++`

!!! warning "UCRT は非対応"



MSYS2 がインストールする可能性のある他の clang（デフォルトのターゲットが適切でない場合があります）や、「Clang」環境（現在は未対応の ucrt がデフォルトです）は使用しないでください。

```
4. Start the build

   ```
   make -j$(nproc)
   ```
```

!!! note "便利なヒント: ディレクトリ内でビルド"
    ```sh
    make O=julia-mingw-w64 configure
    echo 'ifeq ($(BUILDROOT),$(JULIAHOME))
            $(error "in-tree build disabled")
          endif' >> Make.user
    make -C julia-mingw-w64
    ```


### Cross-compiling from Unix (Linux/Mac/WSL)

MinGW-w64 クロスコンパイラを使用すると、Linux、Mac、または Windows Subsystem for Linux（WSL）から Windows 版 Julia をビルドすることもできます。

まず、システムに必要な依存関係が揃っていることを確認してください。wine（>=1.7.5）、システムのコンパイラ、およびいくつかのダウンロード用ツールが必要です。注意: WSL を使用する場合、インストール済みの Cygwin がこの方法に干渉する可能性があります。

**Ubuntu の場合**（他の Linux システムでも、依存パッケージの名前はおそらく似ています）:

```sh
apt-get install wine-stable gcc wget p7zip-full winbind mingw-w64 gfortran-mingw-w64
dpkg --add-architecture i386 && apt-get update && apt-get install wine32 # add sudo to each if needed
# switch all of the following to their "-posix" variants (interactively):
for pkg in i686-w64-mingw32-g++ i686-w64-mingw32-gcc i686-w64-mingw32-gfortran x86_64-w64-mingw32-g++ x86_64-w64-mingw32-gcc x86_64-w64-mingw32-gfortran; do
    sudo update-alternatives --config $pkg
done
```

**Mac の場合**: XCode、XCode コマンドラインツール、X11（現在は [XQuartz](https://www.xquartz.org/)）、および [MacPorts](https://www.macports.org/install.php) または [Homebrew](https://brew.sh/) をインストールします。その後、使用する環境に応じて `port install wine wget mingw-w64` または `brew install wine wget mingw-w64` を実行します。

**続いてビルドを実行します。**

1. `git clone https://github.com/JuliaLang/julia.git julia-win32`
2. `cd julia-win32`
3. `echo override XC_HOST = i686-w64-mingw32 >> Make.user`
4. `make`
5. `make win-extras`（`make binary-dist` を実行する前に必要です）
6. `make binary-dist`、続いて `make exe` を実行し、Windows インストーラーを作成します。
7. `julia-*.exe` インストーラーを対象のマシンに移動します。

64 ビット版 Windows 向けにビルドする場合も、手順は基本的に同じです。`XC_HOST` 内の `i686` を `x86_64` に置き換えるだけです。（注意: Mac では、wine は 32 ビットモードでのみ動作します。）

## Debugging a cross-compiled build under wine

クロスコンパイルした Julia をクロスコンパイル用ホスト上でデバッグする最も効果的な方法は、Windows 版 GDB をインストールし、通常どおり wine 上で実行することです。[as part of the MSYS2 project](https://packages.msys2.org/) で提供されているビルド済みパッケージは、動作が確認されています。GDB パッケージに加えて、python パッケージと termcap パッケージも必要になる場合があります。また、コマンドラインから起動すると、GDB のプロンプトが動作しないことがあります。これは、通常の GDB 起動コマンドの前に `wineconsole` を付けることで回避できます。

## After compiling

上記のいずれかの方法でコンパイルすると、基本的な Julia のビルドが作成されますが、完全な Julia バイナリインストーラーを実行した場合に含まれる追加コンポーネントの一部は作成されません。これらのコンポーネントが必要な場合、最も簡単なのは、`make win-extras`、続いて `make binary-dist`、`make exe` を実行してインストーラーを自分でビルドする方法です。その後、生成されたインストーラーを実行してください。

## Windows Build Debugging

### GDB hangs with Cygwin mintty

  * 代わりに Windows コンソール（cmd）上で GDB を実行してください。mintty 上で Cygwin 以外のアプリケーションを扱う場合、GDB には [may not function properly](https://www.cygwin.com/ml/cygwin/2009-02/msg00531.html)。必要であれば、`cmd /c start` を使って mintty から Windows コンソールを起動できます。

### GDB not attaching to the right process

  * Unix 系のコマンドラインツール（例: `pgrep`）が表示する PID ではなく、Windows タスクマネージャーの PID、または `ps` コマンドの `WINPID` を使用してください。Windows タスクマネージャーで PID 列がデフォルトで表示されていない場合は、追加する必要があります。

### GDB not showing the right backtrace

  * julia プロセスにアタッチする際、GDB が正しいスレッドにアタッチしていない場合があります。`info threads` コマンドですべてのスレッドを表示し、`thread <threadno>` でスレッドを切り替えてください。
  * 32 ビット版 Julia のビルドをデバッグする場合は 32 ビット版 GDB を、64 ビット版 Julia のビルドをデバッグする場合は 64 ビット版 GDB を必ず使用してください。

### Build process is slow/eats memory/hangs my computer

  * Windows の [Superfetch](https://en.wikipedia.org/wiki/Windows_Vista_I/O_technologies#SuperFetch) サービスと [Program Compatibility Assistant](https://blogs.msdn.com/b/cjacks/archive/2011/11/22/managing-the-windows-7-program-compatibility-assistant-pca.aspx) サービスを無効にしてください。これらには MinGW/Cygwin との間で [spurious interactions](https://cygwin.com/ml/cygwin/2011-12/msg00058.html) があることが知られています。

    上記のリンクでも述べられているように、特に `svchost` による過剰なメモリ使用については、タスクマネージャーでメモリ使用量の多い `svchost.exe` プロセスをクリックし、`Go to Services` を選択して調査できます。原因が見つかるまで、子サービスを 1 つずつ無効にしてください。
  * [BLODA](https://cygwin.com/faq/faq.html#faq.using.bloda) に注意してください。このようなソフトウェアの競合を特定するには、[vmmap](https://technet.microsoft.com/en-us/sysinternals/dd535533.aspx) ツールが欠かせません。vmmap を使い、bash、mintty、またはビルドの実行に使用している他の常駐プロセスについて、読み込まれた DLL の一覧を調べてください。基本的に、Windows の System ディレクトリ外にある DLL は*どれも* BLODA の可能性があります。
