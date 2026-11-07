```julia
MultiSelectMenu(options::Vector{String}; pagesize::Int=10, selected=[], kwargs...)
```

Create a MultiSelectMenu object. Use `request(menu::MultiSelectMenu)` to get user input. It returns a `Set` containing the indices of options that were selected by the user.

# Arguments

  * `options::Vector{String}`: Options to be displayed
  * `pagesize::Int=10`: The number of options to be displayed at one time, the menu will scroll if length(options) > pagesize
  * `selected=[]`: pre-selected items. `i ∈ selected` means that `options[i]` is preselected.

Any additional keyword arguments will be passed to [`TerminalMenus.MultiSelectConfig`](@ref).

!!! compat "Julia 1.6"
    The `selected` argument requires Julia 1.6 or later.

