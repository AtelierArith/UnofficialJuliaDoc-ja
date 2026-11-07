```julia
html([io::IO], md)
```

Output the contents of the Markdown object `md` in HTML format, either writing to an (optional) `io` stream or returning a string.

One can alternatively use `show(io, "text/html", md)` or `repr("text/html", md)`, which differ in that they wrap the output in a `<div class="markdown"> ... </div>` element.

# Examples

```jldoctest
julia> html(md"hello _world_")
"<p>hello <em>world</em></p>\n"
```
