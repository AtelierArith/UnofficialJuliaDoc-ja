```julia
hex2bytes!(dest::AbstractVector{UInt8}, itr)
```

16進数文字列を表すバイトのイテラブル`itr`を、バイナリ表現に変換します。[`hex2bytes`](@ref)と同様ですが、出力は`dest`にインプレースで書き込まれます。`dest`の長さは、`itr`の長さの半分でなければなりません。

!!! compat "Julia 1.7"
    UInt8を生成するイテレータを使ってhex2bytes!を呼び出すには、バージョン1.7が必要です。それ以前のバージョンでは、呼び出す前にイテラブルをcollectしてください。

