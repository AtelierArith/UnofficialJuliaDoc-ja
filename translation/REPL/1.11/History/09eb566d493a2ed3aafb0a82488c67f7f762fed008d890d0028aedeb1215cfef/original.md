```julia
redisplay_candidates(io::IO, oldstate::SelectorState, oldrows::Int, newstate::SelectorState, newrows::Int)
```

Diff and redraw the candidate list pane between two states.

Only lines that changed (entry text, selection, hover, width) are reprinted; unchanged lines remain.
