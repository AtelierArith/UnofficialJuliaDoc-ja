```julia
latex([io::IO], md)
```

Markdownオブジェクト`md`の内容をLaTeX形式で出力します。出力先として（任意の）`io`ストリームを指定するか、文字列として返すことができます。

代わりに`show(io, "text/latex", md)`または`repr("text/latex", md)`を使用することもできます。

# Examples

```jldoctest
julia> latex(md"hello _world_")
"hello \\emph{world}\n\n"
```
