```julia
hex2bytes(itr)
```

16進数の各桁を表すASCIIコードの反復可能オブジェクト `itr` を受け取り、その2進表現に対応するバイト列 `Vector{UInt8}` を返します。`itr` の連続する各2桁の16進数が、返されるベクトル内の1バイトの値になります。

`itr` の長さは偶数でなければなりません。返される配列の長さは `itr` の半分です。インプレース版については [`hex2bytes!`](@ref) を、逆変換については [`bytes2hex`](@ref) を参照してください。

!!! compat "Julia 1.7"
    `hex2bytes` を呼び出す際、`UInt8` の値を生成するイテレーターを使うには、Julia 1.7 以降が必要です。それ以前のバージョンでは、`hex2bytes` を呼び出す前にイテレーターを `collect` できます。


# Examples

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
