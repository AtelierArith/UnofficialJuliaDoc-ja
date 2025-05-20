```
bitrotate(x::Base.BitInteger, k::Integer)
```

`bitrotate(x, k)` はビット単位の回転を実装します。これは、`x` のビットを左に `k` 回回転させた値を返します。`k` の負の値は右に回転します。

!!! compat "Julia 1.5"
    この関数は Julia 1.5 以降が必要です。


参照: [`<<`](@ref), [`circshift`](@ref), [`BitArray`](@ref).

```jldoctest
julia> bitrotate(UInt8(114), 2)
0xc9

julia> bitstring(bitrotate(0b01110010, 2))
"11001001"

julia> bitstring(bitrotate(0b01110010, -2))
"10011100"

julia> bitstring(bitrotate(0b01110010, 8))
"01110010"
```
