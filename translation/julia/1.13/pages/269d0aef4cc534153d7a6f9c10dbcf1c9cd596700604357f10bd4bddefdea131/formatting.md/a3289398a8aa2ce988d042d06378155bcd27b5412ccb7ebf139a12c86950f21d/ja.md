# Code Formatting Guidelines

## General Formatting Guidelines for Julia code contributions

  * [Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/) の最新の開発版に従う
  * コードを読みやすくするために空白を使う
  * 行末に空白を入れない（末尾の空白を避ける）
  * コメントを記述する。特に、アルゴリズムを説明するコメントが望ましい
  * 1行の長さは92文字以内を目安とする
  * 可能な限り、Unicode の同等表記より ASCII の演算子や識別子を使う
  * docstring では言語を「Julia」、実行ファイルを「`julia`」と記述する

## General Formatting Guidelines For C code contributions

  * インデントレベルごとに4つのスペースを使い、タブは使わない
  * `if` と `(` の間にスペースを入れる（`if (x) ...`）
  * 関数定義では、開き `{` の前で改行する
  * 引数が0個の関数宣言には `f(void)` を使う
  * `}` と `else` の間は、`} else {` ではなく改行する
  * `if..else` チェーンの一部で `{ }` を使う場合は、すべての箇所で使う
  * 行末に空白を入れない
