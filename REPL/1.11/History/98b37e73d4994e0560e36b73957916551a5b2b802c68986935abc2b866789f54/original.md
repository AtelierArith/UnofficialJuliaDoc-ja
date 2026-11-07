```julia
componentrows(state::SelectorState) -> (; candidates::Int, preview::Int)
```

Split available terminal rows into candidate list and preview panes.

Clamps preview height between one-third and two-thirds of the usable area.
