```julia
Base.TRACE_EVAL
```

Global control for expression tracing during top-level evaluation. This setting takes priority over the `--trace-eval` command-line option.

Set to:

  * `nothing` - use the command-line `--trace-eval` setting (default)
  * `:no` - disable expression tracing
  * `:loc` - show only location information during evaluation
  * `:full` - show full expressions being evaluated

# Examples

```julia
# Enable full expression tracing
Base.TRACE_EVAL = :full

# Show only locations
Base.TRACE_EVAL = :loc

# Disable tracing (overrides command-line setting)
Base.TRACE_EVAL = :no

# Reset to use command-line setting
Base.TRACE_EVAL = nothing
```

See also: [Command-line Interface](@ref cli) for the `--trace-eval` option.
