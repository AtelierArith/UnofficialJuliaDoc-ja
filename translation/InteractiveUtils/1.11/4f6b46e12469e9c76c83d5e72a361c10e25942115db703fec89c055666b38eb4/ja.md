```julia
peakflops(n::Integer=4096; eltype::DataType=Float64, ntrials::Integer=3, parallel::Bool=false)
```

`peakflops` は、倍精度の [`gemm!`](@ref LinearAlgebra.BLAS.gemm!) を使って、コンピューターのピーク FLOPS を計算します。詳しくは [`LinearAlgebra.peakflops`](@ref) を参照してください。

!!! compat "Julia 1.1"
    この関数は将来、`InteractiveUtils` から `LinearAlgebra` に移動します。Julia 1.1 以降では `LinearAlgebra.peakflops` として利用できます。

