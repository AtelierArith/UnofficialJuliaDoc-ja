```julia
redisplay_all(io::IO, oldstate::SelectorState, newstate::SelectorState, pstate::PromptState; buf)
```

Diff and redraw the entire UI (candidates, preview, prompt).

Uses ANSI sync sequences to update only changed regions between `oldstate` and `newstate`, then reprints the prompt.
