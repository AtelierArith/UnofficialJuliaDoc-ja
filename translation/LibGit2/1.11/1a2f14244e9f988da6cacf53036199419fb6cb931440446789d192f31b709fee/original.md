```
peel([T,] ref::GitReference)
```

Recursively peel `ref` until an object of type `T` is obtained. If no `T` is provided, then `ref` will be peeled until an object other than a [`GitTag`](@ref) is obtained.

  * A `GitTag` will be peeled to the object it references.
  * A [`GitCommit`](@ref) will be peeled to a [`GitTree`](@ref).

!!! note
    Only annotated tags can be peeled to `GitTag` objects. Lightweight tags (the default) are references under `refs/tags/` which point directly to `GitCommit` objects.

