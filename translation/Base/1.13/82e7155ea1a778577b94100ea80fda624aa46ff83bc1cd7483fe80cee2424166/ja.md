```julia
bitreverse(x)
```

整数 `x` のビット順を反転します。`x` は、たとえば `Int16` や `Int32` のように、ビット幅が固定されている必要があります。

!!! compat "Julia 1.5"
    この関数を使用するには、Julia 1.5 以降が必要です。


# Examples

```jldoctest
julia> bitreverse(0x8080808080808080)
0x0101010101010101

julia> reverse(bitstring(0xa06e)) == bitstring(bitreverse(0xa06e))
true
```
