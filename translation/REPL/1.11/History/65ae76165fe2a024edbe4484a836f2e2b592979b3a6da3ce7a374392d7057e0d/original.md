```julia
sync_selection!(state::SelectorState, nadded::Int) -> SelectorState
```

Update the selection in `state` after `nadded` candidates were prepended.

The active selection is shifted to keep referring to the same entries, and any gathered entries among the new candidates are moved into the active selection. The returned state has its scroll and hover fitted to the remaining gathered entries.
