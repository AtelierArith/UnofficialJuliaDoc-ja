```
latex([io::IO], md)
```

Markdownオブジェクト`md`の内容をLaTeX形式で出力します。オプションの`io`ストリームに書き込むか、文字列を返します。

代わりに`show(io, "text/latex", md)`または`repr("text/latex", md)`を使用することもできます。

# 例

```jldoctest
julia> latex(md"hello _world_")
"hello \\emph{world}\n\n"
```
