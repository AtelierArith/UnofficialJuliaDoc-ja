```
parse_components(str::AbstractString, df::DateFormat) -> Array{Any}
```

Parse the string into its components according to the directives in the `DateFormat`. Each component will be a distinct type, typically a subtype of Period. The order of the components will match the order of the `DatePart` directives within the `DateFormat`. The number of components may be less than the total number of `DatePart`.
