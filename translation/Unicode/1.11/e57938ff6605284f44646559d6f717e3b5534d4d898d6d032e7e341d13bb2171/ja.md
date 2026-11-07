```julia
Unicode.normalize(s::AbstractString; keywords...)
Unicode.normalize(s::AbstractString, normalform::Symbol)
```

文字列 `s` を正規化します。デフォルトでは、Unicode のバージョン間の安定性を保証せずに（`compat=false`）、正準合成（`compose=true`）を行います。これにより、等価な文字列のうち最も短いものが生成されますが、以前の Unicode バージョンには存在しない合成文字が導入される場合があります。

また、Unicode 標準の4つの「正規化形式」のいずれかを指定することもできます。`normalform` には、`:NFC`、`:NFD`、`:NFKC`、または `:NFKD` を指定できます。正規化形式 C（正準合成）と D（正準分解）は、同じ抽象的な文字列を表す、見た目が同一の異なる表現を、単一の正準形式に変換します。形式 C のほうがよりコンパクトになります。正規化形式 KC と KD は、さらに「互換等価」な表現も正規化します。つまり、抽象的には類似していても見た目が異なる文字を、単一の正準表現に変換します（たとえば、合字を個々の文字に展開します）。形式 KC のほうがよりコンパクトになります。

より細かな制御や追加の変換を行うには、`Unicode.normalize(s; keywords...)` を呼び出し、以下の真偽値のキーワードオプションを任意の数だけ指定します（`compose` を除き、デフォルトはすべて `false` です）。

  * `compose=false`: 正準合成を行いません。
  * `decompose=true`: 正準合成の代わりに正準分解を行います（`compose=true` が指定されていても無視されます）。
  * `compat=true`: 互換等価な表現を正規化します。
  * `casefold=true`: 大文字と小文字を区別しない文字列比較などのために、Unicode のケースフォールディングを行います。
  * `newline2lf=true`、`newline2ls=true`、または `newline2ps=true`: 各種の改行シーケンス（LF、CRLF、CR、NEL）を、それぞれ改行文字（LF）、行区切り文字（LS）、または段落区切り文字（PS）に変換します。
  * `stripmark=true`: ダイアクリティカルマーク（アクセント記号など）を除去します。
  * `stripignore=true`: Unicode の「デフォルトで無視可能」な文字（ソフトハイフンや左から右へのマークなど）を除去します。
  * `stripcc=true`: 制御文字を除去します。水平タブと改ページ文字はスペースに変換されます。改行変換フラグが指定されていない場合は、改行もスペースに変換されます。
  * `rejectna=true`: 未割り当てのコードポイントが見つかった場合にエラーをスローします。
  * `stable=true`: Unicode のバージョン間の安定性を保証します（以前の Unicode バージョンに存在しない文字を導入しません）。

`chartransform` キーワード（デフォルトは `identity`）を使って、`Integer` のコードポイントをコードポイントに写像する任意の*関数*を渡すこともできます。この関数は、`s` の各文字が処理される際に呼び出され、任意の追加の正規化を行えます。たとえば、`chartransform=Unicode.julia_chartransform` を渡すと、Julia が識別子を解析する際に行う、Julia 固有の文字の正規化をいくつか適用できます（NFC 正規化 `compose=true, stable=true` に加えて適用されます）。

たとえば、NFKC はオプション `compose=true, compat=true, stable=true` に相当します。

# Examples

```jldoctest
julia> "é" == Unicode.normalize("é") #LHS: Unicode U+00e9, RHS: U+0065 & U+0301
true

julia> "μ" == Unicode.normalize("µ", compat=true) #LHS: Unicode U+03bc, RHS: Unicode U+00b5
true

julia> Unicode.normalize("JuLiA", casefold=true)
"julia"

julia> Unicode.normalize("JúLiA", stripmark=true)
"JuLiA"
```

!!! compat "Julia 1.8"
    `chartransform` キーワード引数には Julia 1.8 が必要です。

