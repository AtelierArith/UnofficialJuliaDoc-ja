```julia
AbsIntStackUnwind(sv::AbsIntState)
```

Iterate through all callers of the given `AbsIntState` in the abstract interpretation stack (including the given `AbsIntState` itself), visiting children before their parents (i.e. ascending the tree from the given `AbsIntState`). Note that cycles may be visited in any order.
