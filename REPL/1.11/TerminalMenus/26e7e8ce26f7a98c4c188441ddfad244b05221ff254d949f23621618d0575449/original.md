```
MultiSelectConfig(; charset=:ascii, checked::String, unchecked::String, kwargs...)
```

Configure behavior for a multiple-selection menu via keyword arguments:

  * `checked` is the string to print when an option has been selected. Defaults are "[X]" or "✓", depending on `charset`.
  * `unchecked` is the string to print when an option has not been selected. Defaults are "[ ]" or "⬚", depending on `charset`.

All other keyword arguments are as described for [`TerminalMenus.Config`](@ref). `checked` and `unchecked` are not printed automatically, and should be printed by your `writeline` method.

!!! compat "Julia 1.6"
    `MultiSelectConfig` is available as of Julia 1.6. On older releases use the global `CONFIG`.

