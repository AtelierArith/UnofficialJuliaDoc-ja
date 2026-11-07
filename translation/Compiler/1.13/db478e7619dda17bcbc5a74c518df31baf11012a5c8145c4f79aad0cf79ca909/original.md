```julia
result::InferenceResult
```

A type that represents the result of running type inference on a chunk of code. There are two constructor available:

  * `InferenceResult(mi::MethodInstance, [𝕃::AbstractLattice])` for regular inference, without extended lattice information included in `result.argtypes`.
  * `InferenceResult(mi::MethodInstance, argtypes::Vector{Any}, overridden_by_const::BitVector)` for constant inference, with extended lattice information included in `result.argtypes`.
