```julia
LinearAlgebra.peakflops(n::Integer=4096; eltype::DataType=Float64, ntrials::Integer=3, parallel::Bool=false)
```

`peakflops` computes the peak flop rate of the computer by using double precision [`gemm!`](@ref LinearAlgebra.BLAS.gemm!). By default, if no arguments are specified, it multiplies two `Float64` matrices of size `n x n`, where `n = 4096`. If the underlying BLAS is using multiple threads, higher flop rates are realized. The number of BLAS threads can be set with [`BLAS.set_num_threads(n)`](@ref).

If the keyword argument `eltype` is provided, `peakflops` will construct matrices with elements of type `eltype` for calculating the peak flop rate.

By default, `peakflops` will use the best timing from 3 trials. If the `ntrials` keyword argument is provided, `peakflops` will use those many trials for picking the best timing.

If the keyword argument `parallel` is set to `true`, `peakflops` is run in parallel on all the worker processors. The flop rate of the entire parallel computer is returned. When running in parallel, only 1 BLAS thread is used. The argument `n` still refers to the size of the problem that is solved on each processor.

!!! compat "Julia 1.1"
    This function requires at least Julia 1.1. In Julia 1.0 it is available from the standard library `InteractiveUtils`.

