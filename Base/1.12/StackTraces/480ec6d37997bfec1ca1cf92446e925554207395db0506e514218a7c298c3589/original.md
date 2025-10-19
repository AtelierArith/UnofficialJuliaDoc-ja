```julia
remove_frames!(stack::StackTrace, m::Module)
```

Return the `StackTrace` with all `StackFrame`s from the provided `Module` removed.
