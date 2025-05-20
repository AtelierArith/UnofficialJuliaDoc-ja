```
@doc_str -> MD
```

与えられた文字列をMarkdownテキストとして解析し、行およびモジュール情報を追加して、対応する[`MD`](@ref)オブジェクトを返します。

`@doc_str`は[`Base.Docs`](@ref)モジュールと併用できます。詳細については、[ドキュメント](@ref man-documentation)に関するマニュアルセクションも参照してください。

# 例

```
julia> s = doc"f(x) = 2*x"
  f(x) = 2*x

julia> typeof(s)
Markdown.MD

```
