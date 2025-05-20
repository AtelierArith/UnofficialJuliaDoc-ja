```
latex([io::IO], md)
```

Output the contents of the Markdown object `md` in LaTeX format, either writing to an (optional) `io` stream or returning a string.

One can alternatively use `show(io, "text/latex", md)` or `repr("text/latex", md)`.

# Examples

```jldoctest
julia> latex(md"hello _world_")
"hello \\emph{world}\n\n"
```
