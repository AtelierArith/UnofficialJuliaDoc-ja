```julia
peakflops(n::Integer=4096; eltype::DataType=Float64, ntrials::Integer=3, parallel::Bool=false)
```

`peakflops`は、倍精度[`gemm!`](@ref LinearAlgebra.BLAS.gemm!)を使用してコンピュータのピークフロップレートを計算します。詳細については、[`LinearAlgebra.peakflops`](@ref)を参照してください。

!!! compat "Julia 1.1"
    この関数は将来的に`InteractiveUtils`から`LinearAlgebra`に移動されます。Julia 1.1以降では、`LinearAlgebra.peakflops`として利用可能です。

