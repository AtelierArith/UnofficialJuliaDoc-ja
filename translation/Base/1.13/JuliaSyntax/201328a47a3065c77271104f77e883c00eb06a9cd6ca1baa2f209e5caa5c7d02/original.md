```julia
enable_in_core!([enable=true; freeze_world_age=true, debug_filename=nothing])
```

Connect the JuliaSyntax parser to the Julia runtime so that it replaces the flisp parser for all parsing work. That is, JuliaSyntax will be used for `include()`, `Meta.parse()`, the REPL, etc. To reset to the reference parser, use `enable_in_core!(false)`.

Keyword arguments:

  * `freeze_world_age` - Use a fixed world age for the parser to prevent recompilation of the parser due to any user-defined methods (default `true`).
  * `debug_filename` - File name of parser debug log (defaults to `nothing` or the value of `ENV["JULIA_SYNTAX_DEBUG_FILE"]`).
