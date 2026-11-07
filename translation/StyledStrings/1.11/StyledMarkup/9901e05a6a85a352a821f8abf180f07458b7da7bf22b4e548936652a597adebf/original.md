```julia
styled(content::AbstractString) -> AnnotatedString
```

Construct a styled string. Within the string, `{<specs>:<content>}` structures apply the formatting to `<content>`, according to the list of comma-separated specifications `<specs>`. Each spec can either take the form of a face name, an inline face specification, or a `key=value` pair. The value must be wrapped by `{...}` should it contain any of the characters `,=:{}`.

This is a functional equivalent of the [`@styled_str`](@ref) macro, just without interpolation capabilities.
