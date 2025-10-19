```julia
hex2bytes!(dest::AbstractVector{UInt8}, itr)
```

イテラブル `itr` のバイトを16進数文字列としてバイナリ表現に変換します。これは [`hex2bytes`](@ref) に似ていますが、出力は `dest` にインプレースで書き込まれます。`dest` の長さは `itr` の長さの半分でなければなりません。

!!! compat "Julia 1.7"
    UInt8 を生成するイテレータで hex2bytes! を呼び出すには、バージョン 1.7 が必要です。以前のバージョンでは、呼び出す前にイテラブルを収集することができます。

