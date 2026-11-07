```julia
@doc_str -> MD
```

指定された文字列を Markdown テキストとして解析し、行番号とモジュール情報を追加して、対応する [`MD`](@ref) オブジェクトを返します。

`@doc_str` は [`Base.Docs`](@ref) モジュールと組み合わせて使用できます。詳しくは、[documentation](@ref man-documentation) のマニュアルの項も参照してください。

# Examples

```julia
julia> s = doc"f(x) = 2*x"
  f(x) = 2*x

julia> typeof(s)
Markdown.MD

```
