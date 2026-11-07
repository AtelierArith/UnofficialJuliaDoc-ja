```julia
readexpr!(state::State, pos::Int = first(popfirst!(state.s)) + 1)
```

Read the expression starting at `pos` in `state.content`, and consume `state.s` as appropriate to align the iterator to the end of the expression.
