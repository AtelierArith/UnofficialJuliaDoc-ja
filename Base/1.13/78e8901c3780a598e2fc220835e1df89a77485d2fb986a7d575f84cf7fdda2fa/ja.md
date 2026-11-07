```julia
AbstractLock
```

同期プリミティブを実装する型を表す抽象スーパータイプです。対象となるのは、[`lock`](@ref)、[`trylock`](@ref)、[`unlock`](@ref)、[`islocked`](@ref)です。
