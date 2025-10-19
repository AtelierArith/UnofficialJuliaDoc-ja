```julia
isconst(m::Module, s::Symbol) -> Bool
isconst(g::GlobalRef)
```

Determine whether a global is `const` in a given module `m`, either because it was declared constant or because it was imported from a constant binding. Note that constant-ness is specific to a particular world age, so the result of this function may not be assumed to hold after a world age update.
