```julia
Unicode.normalize(s::AbstractString; keywords...)
Unicode.normalize(s::AbstractString, normalform::Symbol)
```

文字列 `s` を正規化します。デフォルトでは、Unicode バージョンの安定性を保証せずに（`compat=false`）、標準的な合成（`compose=true`）が行われ、可能な限り短い同等の文字列が生成されますが、以前の Unicode バージョンには存在しない合成文字が導入される可能性があります。

また、Unicode 標準の 4 つの「正規形」のいずれかを指定することもできます：`normalform` は `:NFC`、`：NFD`、`：NFKC`、または `:NFKD` にすることができます。正規形 C（標準的な合成）と D（標準的な分解）は、同じ抽象文字列の異なる視覚的に同一の表現を単一の標準形に変換します。形 C はよりコンパクトです。正規形 KC と KD はさらに「互換性のある同等物」を標準化します：それらは、抽象的には類似しているが視覚的には異なる文字を単一の標準的な選択肢に変換します（例：連字を個々の文字に展開します）。形 KC はよりコンパクトです。

また、`Unicode.normalize(s; keywords...)` を呼び出すことで、より細かい制御と追加の変換を得ることができます。この場合、次のブールキーワードオプションの任意の数（すべて `false` にデフォルト設定されているが、`compose` は除く）を指定します：

  * `compose=false`: 標準的な合成を行わない
  * `decompose=true`: 標準的な合成の代わりに標準的な分解を行う（`compose=true` が存在する場合は無視される）
  * `compat=true`: 互換性のある同等物が標準化される
  * `casefold=true`: Unicode のケース折りたたみを行う（例：大文字と小文字を区別しない文字列比較のため）
  * `newline2lf=true`、`newline2ls=true`、または `newline2ps=true`: 様々な改行シーケンス（LF、CRLF、CR、NEL）をそれぞれ行フィード（LF）、行区切り（LS）、または段落区切り（PS）文字に変換する
  * `stripmark=true`: ダイアクリティカルマーク（例：アクセント）を削除する
  * `stripignore=true`: Unicode の「デフォルトで無視可能な」文字（例：ソフトハイフンや左から右へのマーカー）を削除する
  * `stripcc=true`: 制御文字を削除する；水平タブとフォームフィードはスペースに変換される；改行もスペースに変換されるが、改行変換フラグが指定されている場合は除く
  * `rejectna=true`: 未割り当てのコードポイントが見つかった場合はエラーをスローする
  * `stable=true`: Unicode バージョンの安定性を強制する（以前の Unicode バージョンに存在しない文字を決して導入しない）

また、任意の *関数* を渡すために `chartransform` キーワード（デフォルトは `identity`）を使用して、`Integer` コードポイントをコードポイントにマッピングすることができます。これは、処理中の各文字に対して呼び出され、任意の追加の正規化を行うために使用されます。たとえば、`chartransform=Unicode.julia_chartransform` を渡すことで、識別子を解析する際に Julia によって実行されるいくつかの Julia 特有の文字正規化を適用できます（NFC 正規化に加えて：`compose=true, stable=true`）。

たとえば、NFKC はオプション `compose=true, compat=true, stable=true` に対応します。

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
    `chartransform` キーワード引数は Julia 1.8 を必要とします。


```
