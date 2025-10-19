```julia
cancel(m::AbstractMenu)
```

Define what happens when a user cancels ('q' or ctrl-c) a menu. `request()` will always exit after calling this function.
