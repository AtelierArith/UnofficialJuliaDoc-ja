# Reporting and analyzing crashes (segfaults)

とうとう Julia を壊してしまいましたね。おめでとうございます！ ここでは、何か問題が起きたときによく見られる症状について、一般的な対処手順をまとめています。報告にこれらのデバッグ手順で得られた情報を添えると、メンテナーがセグメンテーション違反の原因を突き止めたり、スクリプトが予想より遅い理由を調べたりする際に、大いに役立ちます。

このページを案内された場合は、発生している状況に最も近い症状を見つけ、手順に従って必要なデバッグ情報を生成してください。症状の一覧：

  * [Segfaults during bootstrap (`sysimg.jl`)](@ref)
  * [Segfaults when running a script](@ref)
  * [Errors during Julia startup](@ref)
  * [Other generic segfaults or unreachables reached](@ref)

## [Version/Environment info](@id dev-version-info)

どのようなエラーであっても、使用している Julia のバージョン情報は必ず必要です。Julia の起動時には、バージョン番号と日付を含むヘッダーが表示されます。また、報告には必ず `versioninfo()`（標準ライブラリ [`InteractiveUtils`](@ref InteractiveUtils.versioninfo) からエクスポートされています）の出力も含めてください。

```@repl
using InteractiveUtils
versioninfo()
```

## Segfaults during bootstrap (`sysimg.jl`)

Julia のビルド中、`make` プロセスの終盤で発生するセグメンテーション違反は、Julia が `base/` フォルダー内のコード群を事前解析している際に問題が起きたことを示す、よくある症状です。このプロセスが予期せず終了する原因はさまざまですが、Julia の C コード部分のエラーが原因であることも多いため、通常はデバッグビルドを使い、`gdb` 内でデバッグする必要があります。具体的な手順は次のとおりです。

Julia のデバッグビルドを作成します。

```
$ cd <julia_root>
$ make debug
```

この処理も、通常の `make` の実行時と同じエラーで失敗する可能性が高いことに注意してください。ただし、正確なバックトレースを取得するために `gdb` が必要とするデバッグシンボルを備えた、デバッグ用の実行ファイルは作成されます。次に、`gdb` 内でブートストラップ処理を手動で実行します。

```
$ cd base/
$ gdb -x ../contrib/debug_bootstrap.gdb
```

これにより `gdb` が起動し、Julia のデバッグビルドを使ってブートストラップ処理の実行を試み、セグメンテーション違反が発生した場合（おそらく発生するでしょう）にバックトレースを出力します。バックトレース全体を表示するには、`<enter>` を数回押す必要があるかもしれません。バックトレース、[version info](@ref dev-version-info)、および関連しそうなその他の情報をまとめた [gist](https://gist.github.com) を作成し、その gist へのリンクを添えて GitHub で新しい [issue](https://github.com/JuliaLang/julia/issues?q=is%3Aopen) を作成してください。

## Segfaults when running a script

手順は [Segfaults during bootstrap (`sysimg.jl`)](@ref) とほぼ同じです。Julia のデバッグビルドを作成し、デバッガーの制御下にある Julia プロセス内でスクリプトを実行します。

```
$ cd <julia_root>
$ make debug
$ gdb --args usr/bin/julia-debug <path_to_your_script>
```

`gdb` は、そのまま指示待ちの状態になることに注意してください。`r` と入力してプロセスを実行し、セグメンテーション違反が発生したら `bt` と入力してバックトレースを生成します。

```
(gdb) r
Starting program: /home/sabae/src/julia/usr/bin/julia-debug ./test.jl
...
(gdb) bt
```

バックトレース、[version info](@ref dev-version-info)、および関連しそうなその他の情報をまとめた [gist](https://gist.github.com) を作成し、その gist へのリンクを添えて GitHub で新しい [issue](https://github.com/JuliaLang/julia/issues?q=is%3Aopen) を作成してください。

## Errors during Julia startup

Julia の起動中に、次のようなエラーが発生することがあります（特に、ソースからコンパイルせず、バイナリ配布版を使用している場合）。

```julia
$ julia
exec: error -5
```

これらのエラーは通常、起動処理のごく初期の段階で何かが正しく読み込まれていないことを示しています。何が問題なのかを調べるには、外部ツールを使って `julia` プロセスのディスクアクセスを監視するのが最も有効です。

  * Linux では `strace` を使用します。

    ```
    $ strace julia
    ```
  * OSX では `dtruss` を使用します。

    ```
    $ dtruss -f julia
    ```

`strace` / `dtruss` の出力、[version info](@ref dev-version-info)、およびその他の関連情報をまとめた [gist](https://gist.github.com) を作成し、その gist へのリンクを添えて GitHub で新しい [issue](https://github.com/JuliaLang/julia/issues?q=is%3Aopen) を作成してください。

## Other generic segfaults or unreachables reached

別の箇所でも述べたとおり、`julia` はトレース生成のために `rr` とよく統合されています。Linux では、`julia` を `rr` の制御下で自動的に実行し、クラッシュ後にトレースを共有する機能も含まれています。これはクラッシュのデバッグに非常に役立つため、JuliaLang/julia リポジトリにクラッシュの問題を報告する際には、ぜひ活用してください。`julia` を `rr` の制御下で自動的に実行するには、次のようにします。

```julia
julia --bug-report=rr
```

`rr` のトレースをローカルで生成し、共有はしない場合は、次のようにします。

```julia
julia --bug-report=rr-local
```

これは Linux でのみ動作することに注意してください。詳しくは、[Time Travelling Bug Reporting](https://julialang.org/blog/2020/05/rr/) に関するブログ記事をご覧ください。

## Glossary

このガイドでは、いくつかの用語を略記として使用しています。

  * `<julia_root>` は Julia のソースツリーのルートディレクトリを指します。たとえば、このディレクトリには `base`、`deps`、`src`、`test` などのフォルダーが含まれているはずです。
