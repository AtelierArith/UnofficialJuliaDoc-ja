```julia
peakflops(n::Integer=4096; eltype::DataType=Float64, ntrials::Integer=3, parallel::Bool=false)
```

`peakflops` computes the peak flop rate of the computer by using double precision [`gemm!`](@ref LinearAlgebra.BLAS.gemm!). For more information see [`LinearAlgebra.peakflops`](@ref).

!!! compat "Julia 1.1"
    This function will be moved from `InteractiveUtils` to `LinearAlgebra` in the future. In Julia 1.1 and later it is available as `LinearAlgebra.peakflops`.

