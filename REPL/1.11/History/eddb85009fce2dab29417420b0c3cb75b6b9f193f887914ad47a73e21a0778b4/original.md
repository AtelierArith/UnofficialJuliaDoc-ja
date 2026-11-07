```julia
update_candidates(io::IO, oldcands::CandsState, newcands::CandsState, force::Bool = false)
```

Write an update to `io` that changes the display from `oldcands` to `newcands`.

Only changes are printed, and exactly `length(newcands.entries)` lines are printed.
