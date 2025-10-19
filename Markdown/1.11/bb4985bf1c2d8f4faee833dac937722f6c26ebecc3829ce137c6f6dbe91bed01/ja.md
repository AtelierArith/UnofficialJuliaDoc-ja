```julia
html([io::IO], md)
```

Markdownオブジェクト`md`の内容をHTML形式で出力します。オプションの`io`ストリームに書き込むか、文字列を返します。

代わりに`show(io, "text/html", md)`または`repr("text/html", md)`を使用することもできますが、これらは出力を`<div class="markdown"> ... </div>`要素でラップする点が異なります。

# 例

```jldoctest
julia> html(md"hello _world_")
"<p>hello <em>world</em></p>\n"
```
