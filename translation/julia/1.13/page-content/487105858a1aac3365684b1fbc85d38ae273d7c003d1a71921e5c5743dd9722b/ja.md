# Using Valgrind with Julia

[Valgrind](https://valgrind.org/)は、メモリのデバッグ、メモリリークの検出、プロファイリングを行うためのツールです。このセクションでは、Juliaのメモリ問題をデバッグする際にValgrindを使用するうえで留意すべき点を説明します。

## General considerations

Valgrindはデフォルトで、実行するプログラムに自己書き換えコードが含まれていないと仮定します。ほとんどの場合、この仮定で問題ありませんが、`julia`のようなJITコンパイラでは大きな問題になります。そのため、`valgrind`には必ず`--smc-check=all-non-file`を渡してください。渡さないと、コードがクラッシュしたり、予期しない動作をしたりする可能性があります（しかも、その原因が分かりにくいこともよくあります）。

場合によっては、メモリプールを無効にして`julia`をコンパイルすると、Valgrindでメモリエラーをより検出しやすくなります。コンパイル時フラグ`MEMDEBUG`はJuliaのメモリプールを無効にし、`MEMDEBUG2`はFemtoLispのメモリプールを無効にします。両方のフラグを指定して`julia`をビルドするには、`Make.user`に次の行を追加します。

```make
CFLAGS = -DMEMDEBUG -DMEMDEBUG2
```

プログラムが複数のワーカープロセスを使用する場合は、親プロセスだけでなく、すべてのワーカープロセスをValgrindの下で実行する必要があるでしょう。そのためには、`valgrind`に`--trace-children=yes`を渡します。

また、`valgrind`の使用時に`Unable to find compatible target in system image`でエラーが発生する場合は、ターゲットを`generic`にしてsysimageを再ビルドするか、`JULIA_CPU_TARGET=generic`を指定してjuliaを再ビルドしてみてください。

## Suppressions

Valgrindは実行中に、通常は誤検知の警告を表示します。こうした警告を減らすには、Valgrindに[suppressions file](https://valgrind.org/docs/manual/manual-core.html#manual-core.suppress)を指定すると効果的です。サンプルの抑制ファイルは、Juliaのソース配布物の`contrib/valgrind-julia.supp`に含まれています。

抑制ファイルは、`julia/`のソースディレクトリから次のように使用できます。

```
$ valgrind --smc-check=all-non-file --suppressions=contrib/valgrind-julia.supp ./julia progname.jl
```

表示されたメモリエラーは、バグとして報告するか、追加の抑制ルールとして提供してください。ただし、Valgrindのバージョンによっては[shipped with insufficient default suppressions](https://github.com/JuliaLang/julia/issues/8314#issuecomment-55766210)であるため、バグを報告する前にその点も考慮してください。

## Running the Julia test suite under Valgrind

Juliaのテストスイート全体をValgrindの下で実行できますが、かなり時間がかかります（通常は数時間）。実行するには、`julia/test/`ディレクトリから次のコマンドを実行します。

```
valgrind --smc-check=all-non-file --trace-children=yes --suppressions=$PWD/../contrib/valgrind-julia.supp ../julia runtests.jl all
```

「definite」なメモリリークのレポートを表示するには、`valgrind`にフラグ`--leak-check=full --show-leak-kinds=definite`も渡します。

## Additional spurious warnings

このセクションでは、抑制ファイルにはまだ追加できないものの、無視しても問題のないValgrindの警告を取り上げます。

### Unhandled rr system calls

Valgrindは、[system calls that are specific to rr](https://github.com/rr-debugger/rr/blob/master/src/preload/rrcalls.h)（[Record and Replay Framework](https://rr-project.org/)）を検出すると警告を出します。特に、juliaがrrの下で実行されているかどうかを検出しようとすると、未処理の`1008`システムコールに関する警告が表示されます。

```
--xxxxxx-- WARNING: unhandled amd64-linux syscall: 1008
--xxxxxx-- You may be able to write your own handler.
--xxxxxx-- Read the file README_MISSING_SYSCALL_OR_IOCTL.
--xxxxxx-- Nevertheless we consider this a bug.  Please report
--xxxxxx-- it at http://valgrind.org/support/bug_reports.html.
```

この問題は、Valgrindの開発者から依頼されているため、[has been reported](https://bugs.kde.org/show_bug.cgi?id=446401)に報告してください。

## Caveats

現在、Valgrindは[does not support multiple rounding modes](https://bugs.kde.org/show_bug.cgi?id=136779)。そのため、丸めモードを変更するコードは、Valgrindの下で実行すると異なる動作をします。

一般に、`--smc-check=all-non-file`を設定した後、Valgrindの下でプログラムの動作が変わる場合は、さらに調査する際に`valgrind`へ`--tool=none`を渡すと役立つことがあります。これにより、最小限のValgrind機能だけが有効になり、メモリチェッカーを完全に有効にした場合よりも大幅に高速で実行できます。
