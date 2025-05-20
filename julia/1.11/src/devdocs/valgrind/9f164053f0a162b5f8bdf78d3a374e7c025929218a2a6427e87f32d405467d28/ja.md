# Using Valgrind with Julia

[Valgrind](https://valgrind.org/) は、メモリデバッグ、メモリリーク検出、およびプロファイリングのためのツールです。このセクションでは、Juliaでメモリの問題をデバッグする際にValgrindを使用する際に留意すべき点について説明します。

## General considerations

デフォルトでは、Valgrindは実行するプログラムに自己修正コードがないと仮定します。この仮定はほとんどのケースでうまく機能しますが、`julia`のようなジャストインタイムコンパイラにはひどく失敗します。このため、`--smc-check=all-non-file`を`valgrind`に渡すことが重要です。そうしないと、コードがクラッシュしたり、予期しない動作をする可能性があります（しばしば微妙な方法で）。

場合によっては、Valgrindを使用してメモリエラーをよりよく検出するために、`julia`をメモリプールを無効にしてコンパイルすることが役立ちます。コンパイル時のフラグ`MEMDEBUG`はJuliaのメモリプールを無効にし、`MEMDEBUG2`はFemtoLispのメモリプールを無効にします。両方のフラグを使用して`julia`をビルドするには、`Make.user`に次の行を追加します：

```make
CFLAGS = -DMEMDEBUG -DMEMDEBUG2
```

もう一つ注意すべき点は、プログラムが複数のワーカープロセスを使用している場合、親プロセスだけでなく、すべてのワーカープロセスをValgrindの下で実行したいと思う可能性が高いということです。これを行うには、`--trace-children=yes`を`valgrind`に渡します。

もう一つ注意すべき点があります：`valgrind`を使用している場合に`Unable to find compatible target in system image`というエラーが出たら、ターゲットを`generic`に設定してsysimageを再構築するか、`JULIA_CPU_TARGET=generic`を使ってjuliaを再ビルドしてみてください。

## Suppressions

Valgrindは実行中に虚偽の警告を表示することがよくあります。このような警告の数を減らすために、Valgrindに[suppressions file](https://valgrind.org/docs/manual/manual-core.html#manual-core.suppress)を提供することが役立ちます。サンプルの抑制ファイルは、Juliaのソース配布に`contrib/valgrind-julia.supp`として含まれています。

`suppressions`ファイルは、`julia/`ソースディレクトリから次のように使用できます:

```
$ valgrind --smc-check=all-non-file --suppressions=contrib/valgrind-julia.supp ./julia progname.jl
```

表示されるメモリエラーは、バグとして報告するか、追加の抑制として貢献する必要があります。 Valgrindの一部のバージョンは [shipped with insufficient default suppressions](https://github.com/JuliaLang/julia/issues/8314#issuecomment-55766210) であるため、バグを提出する前に考慮すべきことの一つかもしれません。

## Running the Julia test suite under Valgrind

全体のJuliaテストスイートをValgrindの下で実行することは可能ですが、かなりの時間がかかります（通常は数時間）。 そのためには、`julia/test/`ディレクトリから以下のコマンドを実行してください：

```
valgrind --smc-check=all-non-file --trace-children=yes --suppressions=$PWD/../contrib/valgrind-julia.supp ../julia runtests.jl all
```

「明確な」メモリリークのレポートを表示したい場合は、`valgrind`にフラグ`--leak-check=full --show-leak-kinds=definite`を渡してください。

## Additional spurious warnings

このセクションでは、抑制ファイルに追加できないが、それでも無視しても安全なValgrindの警告について説明します。

### Unhandled rr system calls

Valgrindは、[system calls that are specific to rr](https://github.com/rr-debugger/rr/blob/master/src/preload/rrcalls.h)や[Record and Replay Framework](https://rr-project.org/)のいずれかに遭遇すると警告を発します。特に、juliaがrrの下で実行されているかどうかを検出しようとすると、未処理の`1008`システムコールに関する警告が表示されます。

```
--xxxxxx-- WARNING: unhandled amd64-linux syscall: 1008
--xxxxxx-- You may be able to write your own handler.
--xxxxxx-- Read the file README_MISSING_SYSCALL_OR_IOCTL.
--xxxxxx-- Nevertheless we consider this a bug.  Please report
--xxxxxx-- it at http://valgrind.org/support/bug_reports.html.
```

この問題 [has been reported](https://bugs.kde.org/show_bug.cgi?id=446401) を、Valgrindの開発者に送信してください。

## Caveats

Valgrindは現在 [does not support multiple rounding modes](https://bugs.kde.org/show_bug.cgi?id=136779) であるため、丸めモードを調整するコードはValgrindの下で実行されると異なる動作をします。

一般的に、`--smc-check=all-non-file`を設定した後にプログラムがValgrindの下で異なる動作をすることがわかった場合、さらに調査する際に`valgrind`に`--tool=none`を渡すと役立つかもしれません。これにより、最小限のValgrind機構が有効になりますが、フルメモリチェッカーが有効なときよりもはるかに速く実行されます。
