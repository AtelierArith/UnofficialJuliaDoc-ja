```julia
runprompt!((; term,prompt,pstate,istate), events::Channel{Symbol}, terminal_properties)
```

Drive the prompt input loop until confirm, save, or abort.

Emits `:edit`, `:confirm`, `:save`, or `:abort` into `events`, manages raw mode and bracketed paste, and cleans up on exit.
