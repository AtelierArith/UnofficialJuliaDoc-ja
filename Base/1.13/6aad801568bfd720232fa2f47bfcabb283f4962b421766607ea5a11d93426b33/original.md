```julia
asyncmap!(f, results, c...; ntasks=0, batch_size=nothing)
```

Like [`asyncmap`](@ref), but stores output in `results` rather than returning a collection.

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.

