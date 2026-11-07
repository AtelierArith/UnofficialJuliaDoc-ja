```julia
broadcast_preserving_zero_d(f, As...)
```

Like [`broadcast`](@ref), except in the case of a 0-dimensional result where it returns a 0-dimensional container

Broadcast automatically unwraps zero-dimensional results to be just the element itself, but in some cases it is necessary to always return a container — even in the 0-dimensional case.
