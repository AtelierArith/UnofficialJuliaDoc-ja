```julia
countlines_selected(state::SelectorState) -> Int
```

Count display lines needed for active and gathered entries.

Includes one line per entry plus extra lines for multi-line content and a divider if any gathered entries exist.
