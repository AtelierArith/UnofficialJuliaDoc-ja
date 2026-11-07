```julia
irval(xidx::Int, estate::EscapeState) -> x::Union{Argument,SSAValue}
```

Converts its unique identifier number `xidx` to the original IR element `x::Union{Argument,SSAValue}` that is analyzable in the context of `estate`.

`iridx` is the inverse function of `irval` (not formally), i.e. `iridx(irval(xidx, state), state) === xidx`.
