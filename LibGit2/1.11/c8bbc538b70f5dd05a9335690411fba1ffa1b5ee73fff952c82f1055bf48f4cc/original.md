```
peel([T,] obj::GitObject)
```

Recursively peel `obj` until an object of type `T` is obtained. If no `T` is provided, then `obj` will be peeled until the type changes.

  * A `GitTag` will be peeled to the object it references.
  * A `GitCommit` will be peeled to a `GitTree`.
