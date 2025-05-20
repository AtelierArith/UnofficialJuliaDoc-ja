```
request(m::AbstractMenu; cursor=1)
```

Display the menu and enter interactive mode. `cursor` indicates the item number used for the initial cursor position. `cursor` can be either an `Int` or a `RefValue{Int}`. The latter is useful for observation and control of the cursor position from the outside.

Returns `selected(m)`.

!!! compat "Julia 1.6"
    The `cursor` argument requires Julia 1.6 or later.

