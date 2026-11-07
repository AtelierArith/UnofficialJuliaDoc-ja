```julia
gethover(state::SelectorState) -> Union{HistEntry, Nothing}
```

Return the `HistEntry` under the cursor (hover position), or `nothing`.

Handles positive hover for `candidates` and negative for `gathered`.
