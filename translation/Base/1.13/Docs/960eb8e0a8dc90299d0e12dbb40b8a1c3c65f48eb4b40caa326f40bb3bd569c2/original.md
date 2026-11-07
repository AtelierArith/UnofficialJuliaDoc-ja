`HTML(s)`: Create an object that renders `s` as html.

```julia
HTML("<div>foo</div>")
```

You can also use a stream for large amounts of data:

```julia
HTML() do io
  println(io, "<div>foo</div>")
end
```

!!! warning
    `HTML` is currently exported to maintain backwards compatibility, but this export is deprecated. It is recommended to use this type as [`Docs.HTML`](@ref) or to explicitly import it from `Docs`.

