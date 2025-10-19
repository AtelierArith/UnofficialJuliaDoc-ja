# Reporting and analyzing crashes (segfaults)

ジュリアを壊すことに成功しましたね。おめでとうございます！ここに、何かがうまくいかないときに遭遇する一般的な症状に対処するための手順をまとめました。これらのデバッグ手順の情報を含めることで、セグメンテーションフォルトを追跡したり、スクリプトが予想よりも遅く実行される理由を理解したりする際に、メンテナンス担当者に大いに役立ちます。

このページにアクセスするよう指示された場合は、あなたが経験している症状に最も合致するものを見つけ、要求されたデバッグ情報を生成するための指示に従ってください。症状の表：

  * [Segfaults during bootstrap (`sysimg.jl`)](@ref)
  * [Segfaults when running a script](@ref)
  * [Errors during Julia startup](@ref)
  * [Other generic segfaults or unreachables reached](@ref)

## [Version/Environment info](@id dev-version-info)

エラーに関係なく、あなたが実行しているJuliaのバージョンを常に知る必要があります。Juliaが最初に起動すると、バージョン番号と日付が印刷されたヘッダーが表示されます。また、作成するレポートには、`versioninfo()`（[`InteractiveUtils`](@ref InteractiveUtils.versioninfo)標準ライブラリからエクスポート） の出力も含めてください。

```@repl
using InteractiveUtils
versioninfo()
```

## Segfaults during bootstrap (`sysimg.jl`)

`make` プロセスの終わりにおけるセグメンテーションフォルトは、Julia が `base/` フォルダー内のコードのコーパスを事前解析している際に何かがうまくいかない一般的な症状です。このプロセスが予期せず終了する要因は多岐にわたりますが、Julia の C コード部分のエラーが原因であることが多く、そのため通常は `gdb` 内でデバッグビルドを使用してデバッグする必要があります。明示的には：

Juliaのデバッグビルドを作成するには：

```
$ cd <julia_root>
$ make debug
```

このプロセスは、通常の `make` 呪文と同じエラーで失敗する可能性が高いことに注意してください。ただし、これにより、正確なバックトレースを取得するために必要なデバッグシンボルを `gdb` に提供するデバッグ実行可能ファイルが作成されます。次に、`gdb` 内でブートストラッププロセスを手動で実行します：

```
$ cd base/
$ gdb -x ../contrib/debug_bootstrap.gdb
```

これは `gdb` を起動し、Juliaのデバッグビルドを使用してブートストラッププロセスを実行し、セグメンテーションフォルトが発生した場合にバックトレースを出力しようとします。完全なバックトレースを取得するには、いくつかの回 `<enter>` を押す必要があるかもしれません。バックトレース、[gist](https://gist.github.com)、[version info](@ref dev-version-info)、および考えられるその他の関連情報を作成し、GitHubで新しい [issue](https://github.com/JuliaLang/julia/issues?q=is%3Aopen) を開いて、ギストへのリンクを追加してください。

## Segfaults when running a script

手順は [Segfaults during bootstrap (`sysimg.jl`)](@ref) と非常に似ています。Juliaのデバッグビルドを作成し、デバッグされたJuliaプロセス内でスクリプトを実行します:

```
$ cd <julia_root>
$ make debug
$ gdb --args usr/bin/julia-debug <path_to_your_script>
```

`gdb` はそこで指示を待っています。プロセスを実行するには `r` と入力し、セグメンテーションフォルトが発生したらバックトレースを生成するには `bt` と入力してください。

```
(gdb) r
Starting program: /home/sabae/src/julia/usr/bin/julia-debug ./test.jl
...
(gdb) bt
```

[gist](https://gist.github.com) を作成し、バックトレース、[version info](@ref dev-version-info)、および考えられるその他の関連情報を追加し、新しい [issue](https://github.com/JuliaLang/julia/issues?q=is%3Aopen) をGithubで開き、gistへのリンクを含めてください。

## Errors during Julia startup

時折、Juliaの起動プロセス中にエラーが発生することがあります（特にバイナリディストリビューションを使用している場合、ソースからコンパイルするのではなく）次のようなエラーです：

```julia
$ julia
exec: error -5
```

これらのエラーは通常、起動フェーズの初期段階で何かが正しく読み込まれていないことを示しています。何が問題なのかを特定するための最善の方法は、外部ツールを使用して `julia` プロセスのディスクアクティビティを監査することです。

  * Linuxでは、`strace`を使用します：

    ```
    $ strace julia
    ```
  * OSXでは、`dtruss`を使用します：

    ```
    $ dtruss -f julia
    ```

[gist](https://gist.github.com)を作成し、`strace`/ `dtruss`の出力、[version info](@ref dev-version-info)、およびその他の関連情報を含め、新しい[issue](https://github.com/JuliaLang/julia/issues?q=is%3Aopen)をGithubで開き、gistへのリンクを作成してください。

## Other generic segfaults or unreachables reached

他の場所でも言及されているように、`julia`はトレースを生成するために`rr`との良好な統合を持っています。これには、Linux上で`julia`を`rr`の下で自動的に実行し、クラッシュ後にトレースを共有する機能が含まれています。これは、そのようなクラッシュをデバッグする際に非常に役立ち、JuliaLang/juliaリポジトリにクラッシュの問題を報告する際には強く推奨されます。`rr`の下で`julia`を自動的に実行するには、次のようにします：

```julia
julia --bug-report=rr
```

ローカルで `rr` トレースを生成するが、共有しない場合は、次のようにします:

```julia
julia --bug-report=rr-local
```

この内容はLinuxでのみ動作することに注意してください。[Time Travelling Bug Reporting](https://julialang.org/blog/2020/05/rr/)に関するブログ投稿には、さらに多くの詳細が記載されています。

## Glossary

このガイドでは、いくつかの用語が略語として使用されています：

  * `<julia_root>` は、Juliaソースツリーのルートディレクトリを指します。例えば、`base`、`deps`、`src`、`test` などのフォルダが含まれている必要があります。
