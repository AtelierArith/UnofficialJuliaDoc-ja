```
Unicode.normalize(s::AbstractString; keywords...)
Unicode.normalize(s::AbstractString, normalform::Symbol)
```

文字列 `s` を正規化します。デフォルトでは、Unicodeバージョンの安定性を保証せずに（`compat=false`）、標準的な合成（`compose=true`）が行われ、可能な限り短い同等の文字列が生成されますが、以前のUnicodeバージョンには存在しない合成文字が導入される可能性があります。

また、Unicode標準の4つの「正規形」のいずれかを指定することもできます：`normalform` は `:NFC`、`：NFD`、`：NFKC`、または `:NFKD` にすることができます。正規形C（標準的な合成）とD（標準的な分解）は、同じ抽象文字列の異なる視覚的に同一の表現を単一の標準形に変換します。形Cはよりコンパクトです。正規形KCとKDはさらに「互換性のある同等物」を標準化します：それらは抽象的には類似しているが視覚的には異なる文字を単一の標準的な選択肢に変換します（例：連字を個々の文字に展開します）、形KCはよりコンパクトです。

また、`Unicode.normalize(s; keywords...)` を呼び出すことで、より細かい制御と追加の変換を得ることができます。この場合、以下のブールキーワードオプションの任意の数（すべて `false` にデフォルト設定されているが `compose` は除く）を指定します：

  * `compose=false`: 標準的な合成を行わない
  * `decompose=true`: 標準的な合成の代わりに標準的な分解を行う（`compose=true` が存在する場合は無視されます）
  * `compat=true`: 互換性のある同等物が標準化される
  * `casefold=true`: Unicodeのケース折りたたみを行う（例：大文字と小文字を区別しない文字列比較のため）
  * `newline2lf=true`、`newline2ls=true`、または `newline2ps=true`: 様々な改行シーケンス（LF、CRLF、CR、NEL）をそれぞれ行フィード（LF）、行区切り（LS）、または段落区切り（PS）文字に変換する
  * `stripmark=true`: ダイアクリティカルマーク（例：アクセント）を削除する
  * `stripignore=true`: Unicodeの「デフォルトで無視可能な」文字（例：ソフトハイフンや左から右へのマーカー）を削除する
  * `stripcc=true`: 制御文字を削除する；水平タブとフォームフィードはスペースに変換される；改行もスペースに変換されるが、改行変換フラグが指定されている場合は除く
  * `rejectna=true`: 未割り当てのコードポイントが見つかった場合はエラーをスローする
  * `stable=true`: Unicodeバージョンの安定性を強制する（以前のUnicodeバージョンに欠けている文字を決して導入しない）

また、任意の *関数* を渡すために `chartransform` キーワード（デフォルトは `identity`）を使用して、`Integer` コードポイントをコードポイントにマッピングすることができます。これは、処理中の各文字に対して呼び出され、任意の追加の正規化を行うために使用されます。たとえば、`chartransform=Unicode.julia_chartransform` を渡すことで、識別子を解析する際にJuliaによって実行されるいくつかのJulia特有の文字正規化を適用できます（NFC正規化に加えて：`compose=true, stable=true`）。

たとえば、NFKCはオプション `compose=true, compat=true, stable=true` に対応します。

# 例

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
    `chartransform` キーワード引数はJulia 1.8が必要です。


```
