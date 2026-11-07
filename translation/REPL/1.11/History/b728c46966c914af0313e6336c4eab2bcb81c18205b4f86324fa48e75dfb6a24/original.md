```julia
run_display!((; term,pstate), events::Channel{Symbol}, hist::Vector{HistEntry})
```

Drive the display event loop until confirm or abort.

Listens for navigation, edits, save, and abort events, re-filters history incrementally, and re-renders via `redisplay_all`.
