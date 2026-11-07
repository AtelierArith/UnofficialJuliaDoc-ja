```julia
runsearch() -> (; mode::Union{Symbol, Nothing}, text::String)
```

Launch the interactive REPL history search interface.

Spawns prompt and display tasks, waits for user confirm or abort, and returns the final selection (if any).
