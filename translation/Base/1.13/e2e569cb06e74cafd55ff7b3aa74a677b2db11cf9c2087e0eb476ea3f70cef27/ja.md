```julia
wrap(Array, m::Union{Memory{T}, MemoryRef{T}}, dims)
```

`m`を基盤となるメモリとして使用し、サイズ`dims`の配列を作成します。これは、生のポインターの代わりに`Memory`または`MemoryRef`を利用する、[`unsafe_wrap`](@ref)の安全なバージョンと考えることができます。
