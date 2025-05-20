```
config( <see arguments> )
```

Keyword-only function to configure global menu parameters

# Arguments

  * `charset::Symbol=:na`: ui characters to use (`:ascii` or `:unicode`); overridden by other arguments
  * `cursor::Char='>'|'→'`: character to use for cursor
  * `up_arrow::Char='^'|'↑'`: character to use for up arrow
  * `down_arrow::Char='v'|'↓'`: character to use for down arrow
  * `checked::String="[X]"|"✓"`: string to use for checked
  * `unchecked::String="[ ]"|"⬚")`: string to use for unchecked
  * `scroll::Symbol=:nowrap`: If `:wrap` wrap cursor around top and bottom, if :`nowrap` do not wrap cursor
  * `supress_output::Bool=false`: Ignored legacy argument, pass `suppress_output` as a keyword argument to `request` instead.
  * `ctrl_c_interrupt::Bool=true`: If `false`, return empty on ^C, if `true` throw InterruptException() on ^C

!!! compat "Julia 1.6"
    As of Julia 1.6, `config` is deprecated. Use `Config` or `MultiSelectConfig` instead.

