```julia
GenericMemory{kind::Symbol, T, addrspace=Core.CPU} <: DenseVector{T}
```

Fixed-size [`DenseVector{T}`](@ref DenseVector).

`kind` can currently be either `:not_atomic` or `:atomic`. For details on what `:atomic` implies, see [`AtomicMemory`](@ref)

`addrspace` can currently only be set to `Core.CPU`. It is designed to permit extension by other systems such as GPUs, which might define values such as:

```julia
module CUDA
const Generic = bitcast(Core.AddrSpace{CUDA}, 0)
const Global = bitcast(Core.AddrSpace{CUDA}, 1)
end
```

The exact semantics of these other addrspaces is defined by the specific backend, but will error if the user is attempting to access these on the CPU.

!!! compat "Julia 1.11"
    This type requires Julia 1.11 or later.

