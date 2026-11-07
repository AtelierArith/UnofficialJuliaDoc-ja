```julia
analyze_escapes(ir::IRCode, nargs::Int, get_escape_cache) -> estate::EscapeState
```

Analyzes escape information in `ir`:

  * `nargs`: the number of actual arguments of the analyzed call
  * `get_escape_cache(::MethodInstance) -> Union{Bool,ArgEscapeCache}`: retrieves cached argument escape information
