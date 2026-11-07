```julia
setrounding(f::Function, T, mode)
```

`f`の実行中、浮動小数点型`T`の丸めモードを変更します。これは論理的には次と同等です。

```julia
old = rounding(T)
setrounding(T, mode)
f()
setrounding(T, old)
```

使用可能な丸めモードについては、[`RoundingMode`](@ref)を参照してください。
