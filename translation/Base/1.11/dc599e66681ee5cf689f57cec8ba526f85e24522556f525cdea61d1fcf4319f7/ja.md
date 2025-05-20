```
GenericMemory{kind::Symbol, T, addrspace=Core.CPU} <: DenseVector{T}
```

固定サイズの [`DenseVector{T}`](@ref DenseVector)。

`kind` は現在 `:not_atomic` または `:atomic` のいずれかに設定できます。 `:atomic` が意味する詳細については、[`AtomicMemory`](@ref) を参照してください。

`addrspace` は現在 Core.CPU にのみ設定できます。これは、次のような値を定義する可能性のある他のシステム（GPUなど）による拡張を許可するように設計されています。

```
module CUDA
const Generic = bitcast(Core.AddrSpace{CUDA}, 0)
const Global = bitcast(Core.AddrSpace{CUDA}, 1)
end
```

これらの他の addrspace の正確な意味は特定のバックエンドによって定義されますが、ユーザーが CPU 上でこれらにアクセスしようとするとエラーになります。

!!! compat "Julia 1.11"
    この型は Julia 1.11 以降が必要です。

