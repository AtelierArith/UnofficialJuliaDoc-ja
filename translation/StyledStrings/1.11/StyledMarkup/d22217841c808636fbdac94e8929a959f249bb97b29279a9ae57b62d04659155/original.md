```julia
addpart!(state::State, stop::Int)
```

Create a new part from `state.point` to `stop`, applying all pending styles.

This consumes all the content between `state.point` and  `stop`, and shifts `state.point` to be the index after `stop`.
