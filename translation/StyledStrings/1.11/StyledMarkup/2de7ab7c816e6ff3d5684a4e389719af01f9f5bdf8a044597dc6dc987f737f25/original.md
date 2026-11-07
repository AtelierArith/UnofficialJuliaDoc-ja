```julia
ismacro(state::State) -> Bool
```

Check whether `state` is indicated to come from a macro invocation, according to whether `state.mod` is set or not.

While this function is rather trivial, it clarifies the intent when used instead of just checking `state.mod`.
