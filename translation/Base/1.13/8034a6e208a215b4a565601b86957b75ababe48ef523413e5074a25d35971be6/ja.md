```julia
GenericMemory{kind::Symbol, T, addrspace=Core.CPU} <: DenseVector{T}
```

固定サイズの [`DenseVector{T}`](@ref DenseVector)。

`kind` は、現在 `:not_atomic` または `:atomic` のいずれかです。`:atomic` が意味する内容については、[`AtomicMemory`](@ref) を参照してください。

`addrspace` に設定できるのは、現在 `Core.CPU` のみです。GPU などの他のシステムが、次のような値を定義して拡張できるように設計されています。

```julia
module CUDA
const Generic = bitcast(Core.AddrSpace{CUDA}, 0)
const Global = bitcast(Core.AddrSpace{CUDA}, 1)
end
```

これらの他の addrspace の正確な意味は、各バックエンドによって定義されます。ただし、ユーザーが CPU 上でこれらにアクセスしようとするとエラーになります。

!!! compat "Julia 1.11"
    この型を使用するには、Julia 1.11 以降が必要です。

