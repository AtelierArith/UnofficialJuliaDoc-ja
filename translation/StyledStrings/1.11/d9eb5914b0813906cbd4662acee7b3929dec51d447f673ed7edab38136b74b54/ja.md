```julia
struct SimpleColor
```

文字列のスタイル設定に用いる、色の基本的な表現です。名前付きの色（`:red` など）、または `RGBTuple` を格納できます。後者は、`r`、`g`、`b` の各成分を8ビットで指定する NamedTuple です。

# Constructors

```julia
SimpleColor(name::Symbol)  # e.g. :red
SimpleColor(rgb::RGBTuple) # e.g. (r=1, b=2, g=3)
SimpleColor(r::Integer, b::Integer, b::Integer)
SimpleColor(rgb::UInt32)   # e.g. 0x123456
```

`tryparse(SimpleColor, rgb::String)` も参照してください。
