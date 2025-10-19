```julia
hex2bytes(itr)
```

与えられたASCIIコードの反復可能な`itr`は、16進数の数字のシーケンスに対応し、バイナリ表現に対応する`Vector{UInt8}`のバイトを返します：`itr`内の各連続する2桁の16進数が、返されるベクター内の1バイトの値を与えます。

`itr`の長さは偶数でなければならず、返される配列の長さは`itr`の半分になります。インプレースバージョンについては[`hex2bytes!`](@ref)を、逆については[`bytes2hex`](@ref)を参照してください。

!!! compat "Julia 1.7"
    `UInt8`値を生成するイテレータで`hex2bytes`を呼び出すには、Julia 1.7以降が必要です。以前のバージョンでは、`hex2bytes`を呼び出す前にイテレータを`collect`することができます。


# 例

```jldoctest
julia> s = string(12345, base = 16)
"3039"

julia> hex2bytes(s)
2-element Vector{UInt8}:
 0x30
 0x39

julia> a = b"01abEF"
6-element Base.CodeUnits{UInt8, String}:
 0x30
 0x31
 0x61
 0x62
 0x45
 0x46

julia> hex2bytes(a)
3-element Vector{UInt8}:
 0x01
 0xab
 0xef
```
