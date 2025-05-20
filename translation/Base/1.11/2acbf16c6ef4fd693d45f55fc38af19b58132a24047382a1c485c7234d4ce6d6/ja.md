```
bytes2hex(itr) -> String
bytes2hex(io::IO, itr)
```

イテレータ `itr` のバイトをその16進数文字列表現に変換します。`bytes2hex(itr)` を介して `String` を返すか、`bytes2hex(io, itr)` を介して文字列を `io` ストリームに書き込みます。16進数の文字はすべて小文字です。

!!! compat "Julia 1.7"
    任意のイテレータが `UInt8` 値を生成する `bytes2hex` を呼び出すには、Julia 1.7 以降が必要です。以前のバージョンでは、`bytes2hex` を呼び出す前にイテレータを `collect` できます。


# 例

```jldoctest
julia> a = string(12345, base = 16)
"3039"

julia> b = hex2bytes(a)
2-element Vector{UInt8}:
 0x30
 0x39

julia> bytes2hex(b)
"3039"
```
