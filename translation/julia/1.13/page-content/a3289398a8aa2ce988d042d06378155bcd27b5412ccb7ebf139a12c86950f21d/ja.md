# Code Formatting Guidelines

## General Formatting Guidelines for Julia code contributions

  * [Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/) の最新の開発版に従う
  * コードを読みやすくするため、適切に空白を入れる
  * 行末に空白を入れない（末尾の空白を残さない）
  * コメントを付ける。特に、アルゴリズムを説明するコメントが望ましい
  * 1行の長さは、できる限り92文字以内にする
  * 可能な場合は、Unicodeの演算子や識別子よりASCIIのものを使う
  * docstringでは、言語を「Julia」、実行ファイルを「`julia`」と呼ぶ

## General Formatting Guidelines For C code contributions

  * インデントレベルごとにスペース4つを使い、タブは使わない
  * `if` と `(` の間にスペースを入れる（`if (x) ...`）
  * 関数定義では、開き`{`の前で改行する
  * 引数が0個の関数宣言には `f(void)` を使う
  * `}` と `else` の間は、`} else {` ではなく改行する
  * `if..else` チェーンの一部で `{ }` を使う場合は、すべての部分で使う
  * 行末に空白を入れない
