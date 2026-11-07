```julia
AsyncCollector(f, results, c...; ntasks=0, batch_size=nothing) -> iterator
```

Return an iterator which applies `f` to each element of `c` asynchronously and collects output into `results`.

Keyword args `ntasks` and `batch_size` have the same behavior as in [`asyncmap`](@ref). If `batch_size` is specified, `f` must be a function which operates on an array of argument tuples.

!!! note
    `iterate(::AsyncCollector, state) -> (nothing, state)`. A successful return from `iterate` indicates that the next element from the input collection is being processed asynchronously. It blocks until a free worker task becomes available.


!!! note
    `for _ in AsyncCollector(f, results, c...; ntasks=1) end` is equivalent to `map!(f, results, c...)`.

