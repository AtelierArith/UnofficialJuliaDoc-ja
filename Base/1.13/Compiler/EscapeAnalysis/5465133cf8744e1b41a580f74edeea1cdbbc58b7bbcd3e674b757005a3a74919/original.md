```julia
iridx(x, estate::EscapeState) -> xidx::Union{Int,Nothing}
```

Tries to convert analyzable IR element `x::Union{Argument,SSAValue}` to its unique identifier number `xidx` that is valid in the analysis context of `estate`. Returns `nothing` if `x` isn't maintained by `estate` and thus unanalyzable (e.g. `x::GlobalRef`).

`irval` is the inverse function of `iridx` (not formally), i.e. `irval(iridx(x::Union{Argument,SSAValue}, state), state) === x`.
