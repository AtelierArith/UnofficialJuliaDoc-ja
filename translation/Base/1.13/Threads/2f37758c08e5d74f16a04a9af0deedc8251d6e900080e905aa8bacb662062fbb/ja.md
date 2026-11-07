```julia
SpinLock() <: AbstractSpinLock
```

スピンロックにはパディングがないため、偽共有が発生することがあります。[`PaddedSpinLock`](@ref)も参照してください。

正しい使い方については、[`AbstractSpinLock`](@ref)のドキュメントを参照してください。
