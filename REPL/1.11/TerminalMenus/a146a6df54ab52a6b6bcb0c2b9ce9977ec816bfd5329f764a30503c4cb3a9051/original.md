```julia
pick(m::AbstractMenu, cursor::Int)
```

Defines what happens when a user presses the Enter key while the menu is open. If `true` is returned, `request()` will exit. `cursor` indexes the position of the selection.
