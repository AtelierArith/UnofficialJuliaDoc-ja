```julia
run_state_machine!(state::State)
```

Iterate through `state.s`, applying the parsing rules for the top-level of syntax and calling the relevant specialised functions.

Upon completion, `state.s` should be fully consumed and `state.parts` fully populated (along with `state.errors`).
