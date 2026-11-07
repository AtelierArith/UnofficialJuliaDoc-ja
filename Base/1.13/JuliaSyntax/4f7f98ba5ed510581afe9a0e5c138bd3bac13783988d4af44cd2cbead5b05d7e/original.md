```julia
parse!(stream::ParseStream; rule=:all)
```

Parse Julia source code from a [`ParseStream`](@ref) object. Output tree data structures may be extracted from `stream` with the [`build_tree`](@ref) function.

`rule` may be any of

  * `:all` (default) — parse a whole "file" of top level statements. In this mode, the parser expects to fully consume the input.
  * `:statement` — parse a single statement, or statements separated by semicolons.
  * `:atom` — parse a single syntax "atom": a literal, identifier, or parenthesized expression.
