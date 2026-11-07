```julia
html([io::IO], md)
```

Markdown オブジェクト `md` の内容を HTML 形式で出力します。出力先として（任意で）`io` ストリームを指定するか、文字列として返すことができます。

別の方法として `show(io, "text/html", md)` または `repr("text/html", md)` を使用できます。これらは、出力を `<div class="markdown"> ... </div>` 要素で囲む点が異なります。

# Examples

```jldoctest
julia> html(md"hello _world_")
"<p>hello <em>world</em></p>\n"
```
