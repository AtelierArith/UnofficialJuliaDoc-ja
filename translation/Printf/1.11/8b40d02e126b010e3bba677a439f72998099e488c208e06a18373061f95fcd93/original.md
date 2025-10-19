```julia
Printf.Format(format_str)
```

Create a C printf-compatible format object that can be used for formatting values.

The input `format_str` can include any valid format specifier character and modifiers.

A `Format` object can be passed to `Printf.format(f::Format, args...)` to produce a formatted string, or `Printf.format(io::IO, f::Format, args...)` to print the formatted string directly to `io`.

For convenience, the `Printf.format"..."` string macro form can be used for building a `Printf.Format` object at macro-expansion-time.

!!! compat "Julia 1.6"
    `Printf.Format` requires Julia 1.6 or later.

