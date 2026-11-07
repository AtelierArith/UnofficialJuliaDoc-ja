```julia
struct SimpleColor
```

文字列のスタイル設定に使用する、色の基本的な表現です。名前付きの色（`:red`など）か、ビット深度が8の`r`、`g`、`b`色を指定するNamedTuple（`RGBTuple`）のいずれかを格納できます。

# Constructors

```julia
SimpleColor(name::Symbol)  # e.g. :red
SimpleColor(rgb::RGBTuple) # e.g. (r=1, b=2, g=3)
SimpleColor(r::Integer, b::Integer, b::Integer)
SimpleColor(rgb::UInt32)   # e.g. 0x123456
```

`tryparse(SimpleColor, rgb::String)`も参照してください。
