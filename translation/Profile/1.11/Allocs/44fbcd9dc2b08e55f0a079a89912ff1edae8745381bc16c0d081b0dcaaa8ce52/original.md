```julia
Profile.Allocs.@profile [sample_rate=0.1] expr
```

Profile allocations that happen during `expr`, returning both the result and AllocResults struct.

A sample rate of 1.0 will record everything; 0.0 will record nothing.

```julia
julia> Profile.Allocs.@profile sample_rate=0.01 peakflops()
1.03733270279065e11

julia> results = Profile.Allocs.fetch()

julia> last(sort(results.allocs, by=x->x.size))
Profile.Allocs.Alloc(Vector{Any}, Base.StackTraces.StackFrame[_new_array_ at array.c:127, ...], 5576)
```

See the profiling tutorial in the Julia documentation for more information.

!!! compat "Julia 1.11"
    Older versions of Julia could not capture types in all cases. In older versions of Julia, if you see an allocation of type `Profile.Allocs.UnknownType`, it means that the profiler doesn't know what type of object was allocated. This mainly happened when the allocation was coming from generated code produced by the compiler. See [issue #43688](https://github.com/JuliaLang/julia/issues/43688) for more info.

    Since Julia 1.11, all allocations should have a type reported.


!!! compat "Julia 1.8"
    The allocation profiler was added in Julia 1.8.

