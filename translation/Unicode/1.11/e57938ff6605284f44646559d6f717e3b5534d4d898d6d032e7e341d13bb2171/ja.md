```julia
Unicode.normalize(s::AbstractString; keywords...)
Unicode.normalize(s::AbstractString, normalform::Symbol)
```

文字列 `s` を正規化します。デフォルトでは、Unicode のバージョン間の安定性を保証せずに、正準合成（`compose=true`）を行います（`compat=false`）。これにより、可能な限り短い等価文字列が得られますが、以前の Unicode バージョンには存在しない合成文字が導入される場合があります。

また、Unicode 標準で定義されている4つの「正規形」のいずれかを指定することもできます。`normalform` には、`:NFC`、`:NFD`、`:NFKC`、`:NFKD` を指定できます。正規形 C（正準合成）と D（正準分解）は、見た目は同じでも異なる表現を持つ文字列を、単一の正準形に変換します。C のほうがよりコンパクトです。KC と KD はさらに「互換等価」な文字も正準化します。つまり、抽象的には似ていても見た目が異なる文字を、単一の正準形に変換します（たとえば、合字を個々の文字に展開します）。KC のほうがよりコンパクトです。

より細かな制御や追加の変換を行うには、`Unicode.normalize(s; keywords...)` を呼び出します。次のブール値キーワードオプションを任意の数だけ指定できます（`compose` を除き、デフォルトはすべて `false` です）。

  * `compose=false`: 正準合成を行わない
  * `decompose=true`: 正準合成の代わりに正準分解を行う（指定されていても `compose=true` は無視される）
  * `compat=true`: 互換等価な文字を正準化する
  * `casefold=true`: Unicode のケースフォールディングを行う（大文字・小文字を区別しない文字列比較などに使用）
  * `newline2lf=true`、`newline2ls=true`、または `newline2ps=true`: さまざまな改行シーケンス（LF、CRLF、CR、NEL）を、それぞれラインフィード（LF）、行区切り（LS）、段落区切り（PS）文字に変換する
  * `stripmark=true`: ダイアクリティカルマーク（アクセントなど）を除去する
  * `stripignore=true`: Unicode の「デフォルト無視可能」文字（ソフトハイフンや左から右へのマーカーなど）を除去する
  * `stripcc=true`: 制御文字を除去する。水平タブとフォームフィードは空白に変換される。改行変換フラグが指定されていない場合、改行も空白に変換される
  * `rejectna=true`: 未割り当てのコードポイントが見つかった場合にエラーをスローする
  * `stable=true`: Unicode のバージョン間の安定性を保証する（以前の Unicode バージョンに存在しない文字を決して導入しない）

`chartransform` キーワード（デフォルトは `identity`）を使って、任意の *関数* を渡すこともできます。この関数は `Integer` コードポイントを別のコードポイントに対応付け、`s` の各文字が処理される際に呼び出されます。これにより、任意の追加正規化を行えます。たとえば、`chartransform=Unicode.julia_chartransform` を渡すと、識別子の解析時に Julia が行う、Julia 固有の文字正規化をいくつか適用できます（NFC 正規化に加えて行われます: `compose=true, stable=true`）。

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

