```julia
AtomicMemory{T} == GenericMemory{:atomic, T, Core.CPU}
```

固定サイズの [`DenseVector{T}`](@ref DenseVector)。その個々の要素への取得は原子的に行われます（デフォルトでは `:monotonic` 順序）。

!!! warning
    `AtomicMemory` へのアクセスは、[`@atomic`](@ref) マクロを使用するか、低レベルのインターフェース関数 `Base.getindex_atomic`、`Base.setindex_atomic!`、`Base.setindexonce_atomic!`、`Base.swapindex_atomic!`、`Base.modifyindex_atomic!`、および `Base.replaceindex_atomic!` を使用して行う必要があります。


詳細については、[Atomic Operations](@ref man-atomic-operations) およびマクロ [`@atomic`](@ref)、[`@atomiconce`](@ref)、[`@atomicswap`](@ref)、および [`@atomicreplace`](@ref) を参照してください。

!!! compat "Julia 1.11"
    この型は Julia 1.11 以降が必要です。


!!! compat "Julia 1.12"
    低レベルのインターフェース関数または `@atomic` マクロは Julia 1.12 以降が必要です。

