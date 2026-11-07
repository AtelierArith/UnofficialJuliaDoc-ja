```julia
InitialOptimizations(next) isa Base.Sort.Algorithm
```

Attempt to apply a suite of low-cost optimizations to the input vector before sorting. These optimizations may be automatically applied by the `sort!` family of functions when `alg=InsertionSort`, `alg=MergeSort`, or `alg=QuickSort` is passed as an argument.

`InitialOptimizations` is an implementation detail and subject to change or removal in future versions of Julia.

If `next` is stable, then `InitialOptimizations(next)` is also stable.

The specific optimizations attempted by `InitialOptimizations` are [`SubArrayOptimization`](@ref), [`MissingOptimization`](@ref), [`BoolOptimization`](@ref), dispatch to [`InsertionSort`](@ref) for inputs with `length <= 10`, and [`IEEEFloatOptimization`](@ref).
