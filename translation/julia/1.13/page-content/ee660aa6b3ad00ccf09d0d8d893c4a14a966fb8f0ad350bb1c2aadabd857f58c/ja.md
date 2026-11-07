# Writing tests

テストはいくらあっても足りません。[code coverage at Codecov](https://codecov.io/github/JuliaLang/julia) を確認し、改善に協力してください。

1. https://codecov.io/github/JuliaLang/julia. にアクセスします。
2. ソースファイルを調べ、テストされていない機能（赤色で強調表示されています）のうち、テストを書けそうなものを探します。
3. その機能を検証するテストを書きます。既存のファイルに追加しても、新しいファイルを作成してもかまいません。新しいテストファイルを作成する場合は、`test/choosetests.jl` にあるテスト一覧に追加してください。テストの仕組みについては、https://docs.julialang.org/en/v1/stdlib/Test/ が参考になります。
4. `make test-all` を実行して Julia を再ビルドし、新しいテストを実行します。`base` でバグを修正したり機能を追加したりした場合は、これによりテストが通ることと、不要な空白が混入していないことを確認できます。
5. テストをプルリクエスト（PR）として提出します。

  * ビルドボットの設定コードは https://github.com/staticfloat/julia-buildbot で管理されています。
  * 現在のビルドボットの設定は https://build.julialang.org/builders で確認できます。
  * コードカバレッジについて詳しくは、[Issue 9493](https://github.com/JuliaLang/julia/issues/9493) と [issue 11885](https://github.com/JuliaLang/julia/issues/11885) を参照してください。

コードカバレッジを見ると、まだ「概念実証」テストが必要な機能がわかります。こうしたテストは重要です。また、整数型の変換先の値が、いずれかの整数型の範囲の最大値に近い場合など、扱いの難しい境界ケースのテストも重要です。Codecov で関数にすでにカバレッジがある場合でも、境界ケースのテストを追加すると役立つことがあります。
