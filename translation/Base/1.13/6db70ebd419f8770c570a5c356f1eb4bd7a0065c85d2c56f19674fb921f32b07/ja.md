```julia
AtomicMemory{T} == GenericMemory{:atomic, T, Core.CPU}
```

固定サイズの[`DenseVector{T}`](@ref DenseVector)です。個々の要素の取得はアトミックに行われます（デフォルトでは`:monotonic`順）。

!!! warning
    `AtomicMemory`へのアクセスには、[`@atomic`](@ref)マクロ、または低レベルのインターフェース関数である`Base.getindex_atomic`、`Base.setindex_atomic!`、`Base.setindexonce_atomic!`、`Base.swapindex_atomic!`、`Base.modifyindex_atomic!`、`Base.replaceindex_atomic!`のいずれかを使用する必要があります。


詳しくは[Atomic Operations](@ref man-atomic-operations)、および[`@atomic`](@ref)、[`@atomiconce`](@ref)、[`@atomicswap`](@ref)、[`@atomicreplace`](@ref)の各マクロを参照してください。

!!! compat "Julia 1.11"
    この型を使用するには、Julia 1.11以降が必要です。


!!! compat "Julia 1.12"
    低レベルのインターフェース関数または`@atomic`マクロを使用するには、Julia 1.12以降が必要です。

