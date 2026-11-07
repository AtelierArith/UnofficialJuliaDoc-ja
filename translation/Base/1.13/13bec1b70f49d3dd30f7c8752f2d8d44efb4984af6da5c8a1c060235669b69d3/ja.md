```julia
hex2bytes!(dest::AbstractVector{UInt8}, itr)
```

16進数文字列を表すバイトのイテラブル`itr`を、[`hex2bytes`](@ref)と同様にバイナリ表現へ変換します。ただし、出力は`dest`にインプレースで書き込まれます。`dest`の長さは、`itr`の長さの半分でなければなりません。

!!! compat "Julia 1.7"
    UInt8を生成するイテレーターをhex2bytes!に渡すには、バージョン1.7が必要です。それ以前のバージョンでは、呼び出す前にイテラブルをcollectしてください。

