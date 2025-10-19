```julia
@doc_str -> MD
```

与えられた文字列をMarkdownテキストとして解析し、行およびモジュール情報を追加して対応する[`MD`](@ref)オブジェクトを返します。

`@doc_str`は[`Base.Docs`](@ref)モジュールと一緒に使用できます。詳細については、[documentation](@ref man-documentation)に関するマニュアルセクションも参照してください。

# 例

```julia
julia> s = doc"f(x) = 2*x"
  f(x) = 2*x

julia> typeof(s)
Markdown.MD

```
