# Reporting and analyzing crashes (segfaults)

Julia を壊すことができたのですね。おめでとうございます！ ここでは、何か問題が起きたときによく見られる症状について、一般的な対処手順をまとめています。これらのデバッグ手順で得られた情報を報告に含めると、メンテナーがセグメンテーション違反の原因を突き止めたり、スクリプトが予想より遅い理由を調べたりするうえで大いに役立ちます。

このページを案内された場合は、発生している状況に最も近い症状を探し、手順に従って必要なデバッグ情報を生成してください。症状の一覧：

  * [Segfaults during bootstrap (`sysimg.jl`)](@ref)
  * [Segfaults when running a script](@ref)
  * [Errors during Julia startup](@ref)
  * [Other generic segfaults or unreachables reached](@ref)

## [Version/Environment info](@id dev-version-info)

どのようなエラーであっても、使用している Julia のバージョン情報は必ず必要です。Julia の起動時には、バージョン番号と日付を含むヘッダーが表示されます。また、報告を作成する際は必ず、標準ライブラリ [`InteractiveUtils`](@ref InteractiveUtils.versioninfo) からエクスポートされている `versioninfo()` の出力も含めてください。

```@repl
using InteractiveUtils
versioninfo()
```

## Segfaults during bootstrap (`sysimg.jl`)

Julia のビルドにおける `make` 処理の終盤で発生するセグメンテーション違反は、Julia が `base/` フォルダー内のコード群を事前解析している間に何らかの問題が起きたときによく見られる症状です。この処理が予期せず終了する原因はさまざまですが、Julia の C コード部分のエラーが原因であることも多いため、通常はデバッグビルドを `gdb` 内で実行してデバッグする必要があります。具体的な手順は次のとおりです。

Julia のデバッグビルドを作成します。

```
$ cd <julia_root>
$ make debug
```

この処理も、通常の `make` の実行時と同じエラーで失敗する可能性が高い点に注意してください。ただし、これによってデバッグ用の実行ファイルが作成され、正確なバックトレースを取得するために必要なデバッグシンボルを `gdb` が利用できるようになります。次に、`gdb` 内でブートストラップ処理を手動で実行します。

```
$ cd base/
$ gdb -x ../contrib/debug_bootstrap.gdb
```

これにより `gdb` が起動し、Julia のデバッグビルドを使ってブートストラップ処理の実行を試み、セグメンテーション違反が発生した場合（おそらく発生するでしょう）にバックトレースを出力します。バックトレース全体を表示するには、`<enter>` を何度か押す必要があるかもしれません。バックトレース、[version info](@ref dev-version-info)、および思い当たるその他の関連情報を含めた [gist](https://gist.github.com) を作成し、その gist へのリンクを添えて GitHub で新しい [issue](https://github.com/JuliaLang/julia/issues?q=is%3Aopen) を作成してください。

## Segfaults when running a script

手順は [Segfaults during bootstrap (`sysimg.jl`)](@ref) とほぼ同じです。Julia のデバッグビルドを作成し、デバッガー上で動作する Julia プロセス内でスクリプトを実行します。

```
$ cd <julia_root>
$ make debug
$ gdb --args usr/bin/julia-debug <path_to_your_script>
```

`gdb` はコマンドを待つ状態になる点に注意してください。`r` と入力してプロセスを実行し、セグメンテーション違反が発生したら `bt` と入力してバックトレースを生成します。

```
(gdb) r
Starting program: /home/sabae/src/julia/usr/bin/julia-debug ./test.jl
...
(gdb) bt
```

バックトレース、[version info](@ref dev-version-info)、および思い当たるその他の関連情報を含めた [gist](https://gist.github.com) を作成し、その gist へのリンクを添えて GitHub で新しい [issue](https://github.com/JuliaLang/julia/issues?q=is%3Aopen) を作成してください。

## Errors during Julia startup

Julia の起動処理中に、次のようなエラーが発生することがあります。特に、ソースからコンパイルするのではなく、バイナリ配布版を使用している場合に見られます。

```julia
$ julia
exec: error -5
```

これらのエラーは通常、起動のごく初期段階で何かが正しく読み込まれていないことを示します。原因を調べるには、外部ツールを使って `julia` プロセスのディスクアクセスを調査するのが最も有効です。

  * Linux では `strace` を使用します。

    ```
    $ strace julia
    ```
  * OSX では `dtruss` を使用します。

    ```
    $ dtruss -f julia
    ```

`strace` / `dtruss` の出力、[version info](@ref dev-version-info)、およびその他の関連情報を含めた [gist](https://gist.github.com) を作成し、その gist へのリンクを添えて GitHub で新しい [issue](https://github.com/JuliaLang/julia/issues?q=is%3Aopen) を作成してください。

## Other generic segfaults or unreachables reached

別の箇所でも述べたように、`julia` はトレース生成のために `rr` と緊密に連携しています。Linux では、`julia` を `rr` の下で自動的に実行し、クラッシュ後にトレースを共有することもできます。これはクラッシュのデバッグに非常に役立つため、JuliaLang/julia リポジトリにクラッシュの問題を報告する際には、ぜひ利用してください。`julia` を `rr` の下で自動的に実行するには、次のようにします。

```julia
julia --bug-report=rr
```

`rr` のトレースをローカルで生成し、共有はしない場合は、次のようにします。

```julia
julia --bug-report=rr-local
```

この機能は Linux でのみ動作する点に注意してください。詳しくは、[Time Travelling Bug Reporting](https://julialang.org/blog/2020/05/rr/) に関するブログ記事を参照してください。

## Glossary

このガイドでは、いくつかの表記を略記として使用しています。

  * `<julia_root>` は Julia ソースツリーのルートディレクトリを指します。このディレクトリには、`base`、`deps`、`src`、`test` などのフォルダーが含まれているはずです。
