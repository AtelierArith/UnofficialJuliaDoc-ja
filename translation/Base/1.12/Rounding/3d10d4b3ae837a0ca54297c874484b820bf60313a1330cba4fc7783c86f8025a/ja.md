```julia
setrounding(f::Function, T, mode)
```

浮動小数点型 `T` の丸めモードを `f` の実行中に変更します。これは論理的に次のように等価です：

```julia
old = rounding(T)
setrounding(T, mode)
f()
setrounding(T, old)
```

利用可能な丸めモードについては [`RoundingMode`](@ref) を参照してください。
