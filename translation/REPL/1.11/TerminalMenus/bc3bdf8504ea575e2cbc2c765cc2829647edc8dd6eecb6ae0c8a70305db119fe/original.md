```
writeline(buf::IO, m::AbstractMenu, idx::Int, iscursor::Bool)
```

Write the option at index `idx` to `buf`. `iscursor`, if `true`, indicates that this item is at the current cursor position (the one that will be selected by hitting "Enter").

If `m` is a `ConfiguredMenu`, `TerminalMenus` will print the cursor indicator. Otherwise the callee is expected to handle such printing.

!!! compat "Julia 1.6"
    `writeline` requires Julia 1.6 or higher.

    On older versions of Julia, this was     `writeLine(buf::IO, m::AbstractMenu, idx, iscursor::Bool)` and `m` is assumed to be unconfigured. The selection and cursor indicators can be obtained from `TerminalMenus.CONFIG`.

    This older function is supported on all Julia 1.x versions but will be dropped in Julia 2.0.

