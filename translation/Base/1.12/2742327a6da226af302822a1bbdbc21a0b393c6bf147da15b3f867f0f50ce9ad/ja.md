```julia
bitreverse(x)
```

整数 `x` のビットの順序を逆にします。`x` は固定ビット幅を持っている必要があります。例えば、`Int16` または `Int32` である必要があります。

!!! compat "Julia 1.5"
    この関数は Julia 1.5 以降が必要です。


# 例

```jldoctest
julia> bitreverse(0x8080808080808080)
0x0101010101010101

julia> reverse(bitstring(0xa06e)) == bitstring(bitreverse(0xa06e))
true
```
