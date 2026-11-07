```julia
x::EscapeInfo ⋤ₑ y::EscapeInfo -> Bool
```

この順序は、`x ⊑ₑ y`が成り立つと安全に仮定できる場合、厳密な順序`⊏ₑ`をわずかに効率化したものとして使用できます。
