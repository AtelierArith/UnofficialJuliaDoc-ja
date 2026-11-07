```julia
RadioMenu(options::Vector{String}; pagesize::Int=10,
                                   keybindings::Vector{Char}=Char[],
                                   kwargs...)
```

Create a RadioMenu object. Use `request(menu::RadioMenu)` to get user input. `request()` returns an `Int` which is the index of the option selected by the user.

# Arguments

  * `options::Vector{String}`: Options to be displayed
  * `pagesize::Int=10`: The number of options to be displayed at one time, the menu will scroll if length(options) > pagesize
  * `keybindings::Vector{Char}=Char[]`: Shortcuts to pick corresponding entry from `options`

Any additional keyword arguments will be passed to [`TerminalMenus.Config`](@ref).

!!! compat "Julia 1.8"
    The `keybindings` argument requires Julia 1.8 or later.

