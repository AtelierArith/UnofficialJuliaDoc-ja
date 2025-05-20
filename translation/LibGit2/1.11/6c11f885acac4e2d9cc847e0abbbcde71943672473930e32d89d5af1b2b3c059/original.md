```
upstream(ref::GitReference) -> Union{GitReference, Nothing}
```

Determine if the branch containing `ref` has a specified upstream branch.

Return either a `GitReference` to the upstream branch if it exists, or [`nothing`](@ref) if the requested branch does not have an upstream counterpart.
