```
UInt
```

Sys.WORD_SIZEビットの符号なし整数型、`UInt <: Unsigned <: Integer`。

[`Int`](@ref Int)と同様に、エイリアス`UInt`は、特定のコンピュータの`Sys.WORD_SIZE`の値に応じて`UInt32`または`UInt64`のいずれかを指すことがあります。

16進数で表示および解析されます：`UInt(15) === 0x000000000000000f`。
