# Windows

このファイルは、Windows上でJuliaをインストールまたはビルドし、使用する方法について説明しています。

一般的なJuliaに関する情報については、[main README](https://github.com/JuliaLang/julia/blob/master/README.md)または[documentation](https://docs.julialang.org)を参照してください。

## General Information for Windows

私たちは、特に [Microsoft Store](https://aka.ms/terminal) からインストールできる Windows Terminal を使用して、最新のターミナルアプリケーションで Julia を実行することを強くお勧めします。

### Line endings

Juliaはバイナリモードのファイルのみを使用します。他の多くのWindowsプログラムとは異なり、ファイルに`\n`を書き込むと、ファイル内に`\n`が得られ、他のビットパターンにはなりません。これは他のオペレーティングシステムで示される動作と一致します。Windows用のGitをインストールしている場合、システムGitを同じ規約を使用するように設定することが推奨されますが、必須ではありません。

```sh
git config --global core.eol lf
git config --global core.autocrlf input
```

または `%USERPROFILE%\.gitconfig` を編集し、行を追加/編集します:

```
[core]
    eol = lf
    autocrlf = input
```

## Binary distribution

Windowsのバイナリ配布インストールノートについては、[https://julialang.org/downloads/platform/#windows](https://julialang.org/downloads/platform/#windows)の指示を参照してください。ただし、すべてのプラットフォームで[using `juliaup`](https://julialang.org/install/)がバイナリを手動でインストールするよりも推奨されます。

## Source distribution

### Cygwin-to-MinGW cross-compiling

WindowsでJuliaをソースからコンパイルする推奨方法は、[Cygwin](https://www.cygwin.com)からクロスコンパイルすることであり、Cygwinのパッケージマネージャーを通じて入手可能なMinGW-w64コンパイラのバージョンを使用します。

1. Cygwin セットアップを [32 bit](https://cygwin.com/setup-x86.exe) または [64 bit](https://cygwin.com/setup-x86_64.exe) からダウンロードして実行してください。32ビットまたは64ビットの Cygwin から、32ビットまたは64ビットの Julia をコンパイルできます。64ビット Cygwin は、やや小さいですが、しばしば最新のパッケージの選択肢があります。

    *高度な*: 次のコマンドを実行することで、ステップ2-4をスキップできます:

    ```sh
    setup-x86_64.exe -s <url> -q -P cmake,gcc-g++,git,make,patch,curl,m4,python3,p7zip,mingw64-i686-gcc-g++,mingw64-i686-gcc-fortran,mingw64-x86_64-gcc-g++,mingw64-x86_64-gcc-fortran
    ```

    replacing `<url>` with a site from [https://cygwin.com/mirrors.html](https://cygwin.com/mirrors.html) or run setup manually first and select a mirror.
2. インストール場所とダウンロードするミラーを選択してください。
3. *パッケージの選択*ステップで、以下を選択してください：

    1. *Devel* カテゴリから: `cmake`, `gcc-g++`, `git`, `make`, `patch`
    2. *ネット*カテゴリから: `curl`
    3. *インタプリタ*（または*Python*）カテゴリから: `m4`, `python3`
    4. *アーカイブ* カテゴリから: `p7zip`
    5. 32ビットのJulia、および*Devel*カテゴリから: `mingw64-i686-gcc-g++` と `mingw64-i686-gcc-fortran`
    6. 64ビットのJulia、および*Devel*カテゴリから: `mingw64-x86_64-gcc-g++` と `mingw64-x86_64-gcc-fortran`
4. Cygwinのインストールが完了したら、インストールされたショートカット *'Cygwin Terminal'* または *'Cygwin64 Terminal'* から開始してください。
5. ソースからJuliaとその依存関係をビルドする:

    1. ジュリアのソースを取得する

        ```sh
        git clone https://github.com/JuliaLang/julia.git
        cd julia
        ```

        Tip: `error: cannot fork() for fetch-pack: Resource temporarily unavailable`というエラーがgitから出た場合は、`~/.bashrc`に`alias git="env PATH=/usr/bin git"`を追加し、Cygwinを再起動してください。
    2. `Make.user`内の`XC_HOST`変数を設定して、MinGW-w64クロスコンパイルを示します。

        ```sh
        echo 'XC_HOST = i686-w64-mingw32' > Make.user     # for 32 bit Julia
        # or
        echo 'XC_HOST = x86_64-w64-mingw32' > Make.user   # for 64 bit Julia
        ```
    3. ビルドを開始する

        ```sh
        make -j 4       # Adjust the number of threads (4) to match your build environment.
        make -j 4 debug # This builds julia-debug.exe
        ```
6. Juliaの実行ファイルを直接使用してJuliaを実行する

    ```sh
    usr/bin/julia.exe
    usr/bin/julia-debug.exe
    ```

!!! note "Pro tip: build both!"
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

[MSYS2](https://www.msys2.org/) は、Windows 用のソフトウェア配布およびビルド環境です。

注意: MSYS2は**64ビット**のWindows 7以降が必要です。

1. MSYS2をインストールして設定します。

    1. 最新のインストーラーをダウンロードして実行してください [64-bit](https://github.com/msys2/msys2-installer/releases/latest) 配布のために。インストーラーの名前は `msys2-x86_64-yyyymmdd.exe` のようになります。
    2. MSYS2シェルを開きます。パッケージデータベースと基本パッケージを更新します：

        `pacman -Syu`
    3. MSYS2を終了して再起動します。残りの基本パッケージを更新します:

        `pacman -Syu`
    4. 次に、Juliaをビルドするために必要なツールをインストールします：

        `pacman -S cmake diffutils git m4 make patch tar p7zip curl python`

        64ビットのJuliaをインストールするには、x86_64バージョンをインストールしてください：

        `pacman -S mingw-w64-x86_64-gcc`

        32ビットのJuliaをインストールするには、i686バージョンをインストールしてください：

        `pacman -S mingw-w64-i686-gcc`
    5. MSYS2の設定が完了しました。これで、MSYS2シェルを`exit`してください。
2. プリビルド依存関係を使用して、Juliaとその依存関係をビルドします。

    1. 新しい [**MINGW64/MINGW32 shell**](https://www.msys2.org/docs/environments/#overview) を開いてください。 現在、mingw32 と mingw64 の両方を使用することはできないため、x86_64 と i686 バージョンをビルドしたい場合は、それぞれの環境で別々にビルドする必要があります。
    2. Juliaのソースをクローンします：

        `git clone https://github.com/JuliaLang/julia.git  cd julia`
    3. ビルドを開始する

        `make -j$(nproc)`

!!! note "Pro tip: build in dir"
    ```sh
    make O=julia-mingw-w64 configure
    echo 'ifeq ($(BUILDROOT),$(JULIAHOME))
            $(error "in-tree build disabled")
          endif' >> Make.user
    make -C julia-mingw-w64
    ```


### Cross-compiling from Unix (Linux/Mac/WSL)

Linux、Mac、またはWindows Subsystem for Linux (WSL)からWindows版のJuliaをビルドするために、MinGW-w64クロスコンパイラを使用することもできます。

まず、システムに必要な依存関係が揃っていることを確認する必要があります。wine (>=1.7.5)、システムコンパイラ、およびいくつかのダウンローダーが必要です。注意: WSLを使用している場合、Cygwinのインストールがこの方法に干渉する可能性があります。

**Ubuntuでは**（他のLinuxシステムでは依存関係の名前は似ている可能性があります）：

```sh
apt-get install wine-stable gcc wget p7zip-full winbind mingw-w64 gfortran-mingw-w64
dpkg --add-architecture i386 && apt-get update && apt-get install wine32 # add sudo to each if needed
# switch all of the following to their "-posix" variants (interactively):
for pkg in i686-w64-mingw32-g++ i686-w64-mingw32-gcc i686-w64-mingw32-gfortran x86_64-w64-mingw32-g++ x86_64-w64-mingw32-gcc x86_64-w64-mingw32-gfortran; do
    sudo update-alternatives --config $pkg
done
```

**Macの場合**: XCode、XCodeコマンドラインツール、X11（現在は [XQuartz](https://www.xquartz.org/)）、および [MacPorts](https://www.macports.org/install.php) または [Homebrew](https://brew.sh/) をインストールします。次に、適切に `port install wine wget mingw-w64` または `brew install wine wget mingw-w64` を実行します。

**ビルドを実行します:**

1. `git clone https://github.com/JuliaLang/julia.git julia-win32`
2. `cd julia-win32`
3. `echo override XC_HOST = i686-w64-mingw32 >> Make.user`
4. `作成`
5. `make win-extras`（`make binary-dist`を実行する前に必要）
6. `make binary-dist` の後に `make exe` を実行して、Windows インストーラーを作成します。
7. `julia-*.exe` インストーラーをターゲットマシンに移動します。

64ビットWindows向けにビルドしている場合、手順は基本的に同じです。`XC_HOST`の`i686`を`x86_64`に置き換えるだけです。（注：Macでは、wineは32ビットモードでのみ実行されます）。

## Debugging a cross-compiled build under wine

クロスコンパイルホスト上でクロスコンパイルされたJuliaのデバッグを最も効果的に行う方法は、Windows版のGDBをインストールし、通常通りwineの下で実行することです。利用可能なプリビルドパッケージ [as part of the MSYS2 project](https://packages.msys2.org/) は動作することが知られています。GDBパッケージの他に、pythonおよびtermcapパッケージも必要になる場合があります。最後に、GDBのプロンプトはコマンドラインから起動した場合に機能しないことがあります。これは、通常のGDBの呼び出しの前に`wineconsole`を追加することで回避できます。

## After compiling

上記のオプションのいずれかを使用してコンパイルすると、基本的なJuliaビルドが作成されますが、フルJuliaバイナリインストーラーを実行した場合に含まれる追加のコンポーネントは含まれません。これらのコンポーネントが必要な場合、最も簡単な方法は、`make win-extras`の後に`make binary-dist`と`make exe`を使用してインストーラーを自分でビルドすることです。その後、生成されたインストーラーを実行します。

## Windows Build Debugging

### GDB hangs with Cygwin mintty

  * Windowsコンソール（cmd）でGDBを実行します。GDB [may not function properly](https://www.cygwin.com/ml/cygwin/2009-02/msg00531.html)をminttyでCygwin以外のアプリケーションと共に使用します。必要に応じて、minttyからWindowsコンソールを起動するために`cmd /c start`を使用できます。

### GDB not attaching to the right process

  * Windows タスクマネージャーから PID を使用するか、`ps` コマンドの `WINPID` を使用してください。デフォルトで表示されていない場合は、PID 列を追加する必要があるかもしれません。

### GDB not showing the right backtrace

  * juliaプロセスにアタッチするとき、GDBが正しいスレッドにアタッチしていない可能性があります。`info threads`コマンドを使用してすべてのスレッドを表示し、`thread <threadno>`でスレッドを切り替えてください。
  * 32ビット版のGDBを使用して32ビットビルドのJuliaをデバッグするか、64ビット版のGDBを使用して64ビットビルドのJuliaをデバッグしてください。

### Build process is slow/eats memory/hangs my computer

  * Windowsの[Superfetch](https://en.wikipedia.org/wiki/Windows_Vista_I/O_technologies#SuperFetch)および[Program Compatibility Assistant](https://blogs.msdn.com/b/cjacks/archive/2011/11/22/managing-the-windows-7-program-compatibility-assistant-pca.aspx)サービスを無効にしてください。これらは、MinGW/Cygwinで[spurious interactions](https://cygwin.com/ml/cygwin/2011-12/msg00058.html)として知られています。

    上記のリンクで述べたように、`svchost`による過剰なメモリ使用は、タスクマネージャーで高メモリの`svchost.exe`プロセスをクリックし、`サービスに移動`を選択することで調査できます。原因が見つかるまで、子サービスを1つずつ無効にしてください。
  * [BLODA](https://cygwin.com/faq/faq.html#faq.using.bloda) に注意してください。 [vmmap](https://technet.microsoft.com/en-us/sysinternals/dd535533.aspx) ツールは、そのようなソフトウェアの競合を特定するために不可欠です。 vmmap を使用して、ビルドを駆動するために使用される bash、mintty、または他の永続プロセスの読み込まれた DLL のリストを検査してください。基本的に、Windows システムディレクトリの外にある *任意の* DLL は潜在的な BLODA です。
