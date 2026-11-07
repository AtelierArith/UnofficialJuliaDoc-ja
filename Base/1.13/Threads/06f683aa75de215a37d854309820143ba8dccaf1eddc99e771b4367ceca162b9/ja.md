```julia
PaddedSpinLock() <: AbstractSpinLock
```

PaddedSpinLocksは、偽共有を避けるため、それぞれが必ず独立したキャッシュラインに配置されるようパディングされています。[`SpinLock`](@ref)も参照してください。

正しい使い方については、[`AbstractSpinLock`](@ref)のドキュメントを参照してください。

!!! compat "Julia 1.13"
    この型を使用するには、Julia 1.13以降が必要です。

