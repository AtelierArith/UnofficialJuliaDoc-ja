# [Writing jldoctests](@id writing-jldoctests)

このページでは、ドキュメント内の`jldoctest`ブロックの書き方と保守方法を説明します。以下のガイドラインに従うことで、doctestの信頼性を保ち、読みやすくできます。

## Filters

実行ごとに変わる可能性のあるテキストが出力に含まれる場合は、必ず`filter =`を使用してください。よくある例を以下に示します。

  * 出力に未定義のメモリを含む配列が含まれる（例：`undef`または`similar`によるもの）
  * 出力に乱数が含まれる
  * 出力に実行時間の情報が含まれる
  * 出力にファイルシステムのパスが含まれる

### Common filter sequences

ドキュメントでは、繰り返し使われるいくつかのパターンを利用しています。

  * `r"int.jl:\\d+"` — 内省マクロから行番号を取り除く。
  * `r"Stacktrace:(\\n \\[0-9]+\\].*)*"` — エラーを示す際にスタックトレースを隠す。
  * `r"Closest candidates.*\\n  .*"` — `MethodError`が出力するメソッド候補を省略する。
  * `r"@ .*"` — `methods`または`@which`の出力からファイルの場所を取り除く。
  * `r"\\@world\\(MyStruct, \\d+:\\d+\\)"` — world ageの数値をフィルタリングする。
  * `r"with \\d+ methods"` — 関数の再定義時にメソッド数を無視する。
  * `r"[0-9\\.]+ seconds \\(.*?\\)"` — メモリ情報を含む実行時間の出力を取り除く。
  * `r"[0-9\\.]+ seconds"` — 単純な実行時間の結果を取り除く。
  * `r"[0-9\\.]+"` — 無名関数などの名前に含まれる数字をフィルタリングする。
  * `r"([A-B] [0-5])"`および`r"[A-B] [X-Z] [0-5]"` — プロセス出力の非決定性に対応する。
  * `r"(world\\nhello|hello\\nworld)"` — 混在した出力の順序をどちらでも許容する。

どれにも当てはまらない場合は、変動するテキストを取り除く正規表現を作成してください。フィルターを使うと、プラットフォームやJuliaのバージョンが異なってもdoctestを安定させられます。

!!! note "docstring内でのバックスラッシュの二重エスケープ"
    docstring内に正規表現フィルターを書く場合は、バックスラッシュを二重にエスケープしてください。たとえば、`r"[\d\.]+"`ではなく`r"[\\d\\.]+"`を使用します。これは、正規表現が作成される前にdocstring自体がエスケープシーケンスを処理するためです。


## Setup code

小さなセットアップ式は、`setup =`オプションを使ってインラインで記述できます。

````
```jldoctest; setup = :(using InteractiveUtils)
...
```
````

セットアップコードが長い場合や、複数のブロックで同じ環境が必要な場合は、`DocTestSetup`メタブロックを使用してください。

````
```@meta
DocTestSetup = :(import Random; Random.seed!(1234))
```
````

その後、次のようにして無効にします。

````
```@meta
DocTestSetup = nothing
```
````

### Teardown code

作成した一時ファイルの削除やカレントディレクトリのリセットなど、後処理コードが必要な場合は、`teardown =`オプションを使用できます。

````
```jldoctest; setup = :(oldpath = pwd(); cd(mktempdir())), teardown = :(cd(oldpath))
...
```
````

## Maintaining state between snippets

関連するdoctestブロックは、`jldoctest`キーワードの後に同じラベルを指定すると、状態を共有できます。マニュアルでは、変更操作を示すためにこのパターンを使用しています。

````
```jldoctest mutation_vs_rebind
julia> a = [1,2,3]
...
```
````

続いて、次のように記述します。

````
```jldoctest mutation_vs_rebind
julia> a[1] = 42
...
```
````

同じ名前のブロックはdoctestの実行時に順番に実行されるため、最初のブロックで作成した変数は後続のブロックでも使用できます。

後の例で結果を保持しておく必要があるスニペットには、ラベルを付けて同じラベルを再利用してください。これにより、セットアップコードの重複を避け、REPLでの操作に近い形にできます。

## Further reading

doctest構文の詳細については、[corresponding Documenter.jl docs](https://documenter.juliadocs.org/stable/man/doctests/)を参照してください。
