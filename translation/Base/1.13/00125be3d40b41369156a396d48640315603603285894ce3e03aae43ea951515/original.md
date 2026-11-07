```julia
AsyncGenerator(f, c...; ntasks=0, batch_size=nothing) -> iterator
```

Apply `f` to each element of `c` using at most `ntasks` asynchronous tasks.

Keyword args `ntasks` and `batch_size` have the same behavior as in [`asyncmap`](@ref). If `batch_size` is specified, `f` must be a function which operates on an array of argument tuples.

!!! note
    `collect(AsyncGenerator(f, c...; ntasks=1))` is equivalent to `map(f, c...)`.

