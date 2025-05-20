```
struct SimpleColor
```

色の基本的な表現で、文字列スタイリングの目的で使用されます。名前付きの色（例えば `:red`）または、8ビット深度の `r`、`g`、`b` 色を指定する NamedTuple である `RGBTuple` を含むことができます。

# コンストラクタ

```julia
SimpleColor(name::Symbol)  # 例: :red
SimpleColor(rgb::RGBTuple) # 例: (r=1, b=2, g=3)
SimpleColor(r::Integer, b::Integer, b::Integer)
SimpleColor(rgb::UInt32)   # 例: 0x123456
```

また、`tryparse(SimpleColor, rgb::String)` も参照してください。
