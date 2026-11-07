```julia
foreignface(face) -> Face
```

Rebuild `face`, a `Face` from another copy of StyledStrings, as one of ours.

More than one copy of StyledStrings can be loaded at once: the REPL runs on a private copy of the stdlib, which is not necessarily the one user code loads (see `Base.require_stdlib`), and only the last loaded copy's `Base.AnnotatedDisplay` hooks are active. A `Face` the REPL attaches to its output (its bracket highlighting, say) then reaches `getface` as a value of a type that is not our `Face`, but has the same fields, holding values of Base types or of the other copy's `SimpleColor`.
