```julia
addpart!(state::State, start::Int, expr, stop::Int)
```

Create a new part based on (the eventual evaluation of) `expr`, running from `start` to `stop`, taking the currently active styles into account.
