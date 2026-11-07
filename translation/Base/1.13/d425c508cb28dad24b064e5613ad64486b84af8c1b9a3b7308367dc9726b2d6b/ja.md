```julia
bswap(n)
```

`n`のバイト順を逆にします。

（現在のネイティブバイト順とビッグエンディアンの間で変換するには、[`ntoh`](@ref)および[`hton`](@ref)も参照してください。）

# Examples

```jldoctest
julia> a = bswap(0x10203040)
0x40302010

julia> bswap(a)
0x10203040

julia> string(1, base = 2)
"1"

julia> string(bswap(1), base = 2)
"100000000000000000000000000000000000000000000000000000000"
```
