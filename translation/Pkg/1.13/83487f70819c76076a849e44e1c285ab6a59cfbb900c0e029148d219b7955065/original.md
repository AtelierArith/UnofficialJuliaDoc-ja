```julia
readonly([state::Bool], [ctx::Context])
```

Get or set the readonly state of the current environment.

# Examples

```julia-repl
julia> Pkg.readonly()  # check current readonly state
false

julia> Pkg.readonly(true)  # enable readonly mode
false  # returns previous state

julia> Pkg.readonly()
true

julia> Pkg.readonly(false)  # disable readonly mode
true
```
