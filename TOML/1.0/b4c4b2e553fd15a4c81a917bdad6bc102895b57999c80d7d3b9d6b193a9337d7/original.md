```
Parser()
```

Constructor for a TOML `Parser`.  Note that in most cases one does not need to explicitly create a `Parser` but instead one directly use use [`TOML.parsefile`](@ref) or [`TOML.parse`](@ref).  Using an explicit parser will however reuse some internal data structures which can be beneficial for performance if a larger number of small files are parsed.
