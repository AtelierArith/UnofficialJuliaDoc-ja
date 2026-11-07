```julia
bitrotate(x::Base.BitInteger, k::Integer)
```

`bitrotate(x, k)`はビット単位のローテーションを行います。`x`のビットを左に`k`回ローテーションした値を返します。`k`が負の値の場合は、右にローテーションします。

!!! compat "Julia 1.5"
    この関数を使用するには、Julia 1.5以降が必要です。


関連項目: [`<<`](@ref)、[`circshift`](@ref)、[`BitArray`](@ref)。

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
