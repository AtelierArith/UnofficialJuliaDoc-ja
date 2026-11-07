```julia
bytes2hex(itr)::String
bytes2hex(io::IO, itr)::Nothing
```

バイトのイテレーター`itr`を16進文字列表現に変換します。`bytes2hex(itr)`を使って`String`を返すか、`bytes2hex(io, itr)`を使って`io`ストリームに文字列を書き込みます。16進文字はすべて小文字です。

!!! compat "Julia 1.7"
    `bytes2hex`に任意のイテレーターを渡し、`UInt8`値を生成させるには、Julia 1.7以降が必要です。それ以前のバージョンでは、`bytes2hex`を呼び出す前に、イテレーターを`collect`できます。


# Examples

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
