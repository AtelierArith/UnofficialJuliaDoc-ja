# Writing tests

テストはいくらあっても十分とは言えません。[code coverage at Codecov](https://codecov.io/github/JuliaLang/julia) を確認し、改善にご協力ください。

1. https://codecov.io/github/JuliaLang/julia. にアクセスします。
2. ソースファイルを見て、まだテストされていない機能（赤色で強調表示されています）のうち、自分でテストを書けそうなものを探します。
3. その機能を実行するテストを書きます。既存のファイルにテストを追加しても、新しいファイルを作成してもかまいません。最も適切だと思う方法を選んでください。新しいテストファイルを追加する場合は、必ず `test/choosetests.jl` のテスト一覧に含めてください。テスト基盤の仕組みを理解するには、https://docs.julialang.org/en/v1/stdlib/Test/ が参考になるかもしれません。
4. `make test-all` を実行して Julia を再ビルドし、新しく追加したテストを実行します。`base` でバグを修正したり機能を追加したりする必要があった場合は、これにより、テストが成功することと、余分な空白を混入させていないことを確認できます。
5. テストをプルリクエスト（PR）として提出します。

  * buildbot の設定コードは、https://github.com/staticfloat/julia-buildbot で管理されています。
  * 現在の buildbot の設定は、https://build.julialang.org/builders で確認できます。
  * コードカバレッジについては、[Issue 9493](https://github.com/JuliaLang/julia/issues/9493) と [issue 11885](https://github.com/JuliaLang/julia/issues/11885) でより詳しく議論されています。

コードカバレッジを見ると、基本的な動作を確認する「概念実証」テストがまだ必要な機能がわかります。こうしたテストは重要ですが、扱いの難しい境界ケースのテストも同様に重要です。たとえば、整数型どうしで変換する際に、変換対象の数値がいずれかの整数型の値域の最大値に近い場合などが該当します。すでに Codecov である程度カバーされている関数でも、境界ケースのテストを追加する意義はあります。
