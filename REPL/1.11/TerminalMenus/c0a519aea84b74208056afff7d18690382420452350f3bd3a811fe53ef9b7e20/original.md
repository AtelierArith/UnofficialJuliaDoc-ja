```
Config(; scroll_wrap=false, ctrl_c_interrupt=true, charset=:ascii, cursor::Char, up_arrow::Char, down_arrow::Char)
```

Configure behavior for selection menus via keyword arguments:

  * `scroll_wrap`, if `true`, causes the menu to wrap around when scrolling above the first or below the last entry
  * `ctrl_c_interrupt`, if `true`, throws an `InterruptException` if the user hits Ctrl-C during menu selection. If `false`, [`TerminalMenus.request`](@ref) will return the default result from [`TerminalMenus.selected`](@ref).
  * `charset` affects the default values for `cursor`, `up_arrow`, and `down_arrow`, and can be `:ascii` or `:unicode`
  * `cursor` is the character printed to indicate the option that will be chosen by hitting "Enter." Defaults are '>' or '→', depending on `charset`.
  * `up_arrow` is the character printed when the display does not include the first entry. Defaults are '^' or '↑', depending on `charset`.
  * `down_arrow` is the character printed when the display does not include the last entry. Defaults are 'v' or '↓', depending on `charset`.

Subtypes of `ConfiguredMenu` will print `cursor`, `up_arrow`, and `down_arrow` automatically as needed, your `writeline` method should not print them.

!!! compat "Julia 1.6"
    `Config` is available as of Julia 1.6. On older releases use the global `CONFIG`.

