```julia
UInt
```

Sys.WORD_SIZE ビットの符号なし整数型、`UInt <: Unsigned <: Integer`。

[`Int`](@ref Int) と同様に、エイリアス `UInt` は、コンピューターごとの `Sys.WORD_SIZE` の値に応じて、`UInt32` または `UInt64` を指すことがあります。

16 進数で表示・解析されます: `UInt(15) === 0x000000000000000f`。
