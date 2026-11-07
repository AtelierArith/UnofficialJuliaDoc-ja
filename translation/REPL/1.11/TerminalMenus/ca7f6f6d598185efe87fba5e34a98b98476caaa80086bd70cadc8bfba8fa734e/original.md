```julia
printmenu(out, m::AbstractMenu, cursoridx::Int; init::Bool=false, oldstate=nothing) -> newstate
```

Display the state of a menu. `init=true` causes `m.pageoffset` to be initialized to start printing at or just above the current cursor location; when `init` is false, the terminal will preserve the current setting of `m.pageoffset` and overwrite the previous display. Returns `newstate`, which can be passed in as `oldstate` on the next call to allow accurate overwriting of the previous display.

!!! compat "Julia 1.6"
    `printmenu` requires Julia 1.6 or higher.

    On older versions of Julia, this was called `printMenu` and it lacked the `state` argument/return value. This older function is supported on all Julia 1.x versions but will be dropped in Julia 2.0.

