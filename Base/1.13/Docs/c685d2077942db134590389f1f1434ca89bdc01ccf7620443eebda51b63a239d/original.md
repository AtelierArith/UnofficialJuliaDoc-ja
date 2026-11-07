`Text(s)`: Create an object that renders `s` as plain text.

```julia
Text("foo")
```

You can also use a stream for large amounts of data:

```julia
Text() do io
  println(io, "foo")
end
```

!!! warning
    `Text` is currently exported to maintain backwards compatibility, but this export is deprecated. It is recommended to use this type as [`Docs.Text`](@ref) or to explicitly import it from `Docs`.

