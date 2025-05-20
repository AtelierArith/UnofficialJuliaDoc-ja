```
pgenerate([::AbstractWorkerPool], f, c...) -> iterator
```

Apply `f` to each element of `c` in parallel using available workers and tasks.

For multiple collection arguments, apply `f` elementwise.

Results are returned in order as they become available.

Note that `f` must be made available to all worker processes; see [Code Availability and Loading Packages](@ref code-availability) for details.
