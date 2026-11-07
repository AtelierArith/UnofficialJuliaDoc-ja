```julia
struct InterConditional
    slot::Int
    thentype
    elsetype
end
```

Similar to `Conditional`, but conveys inter-procedural constraints imposed on call arguments. This is separate from `Conditional` to catch logic errors: the lattice element name is `InterConditional` while processing a call, then `Conditional` everywhere else.
