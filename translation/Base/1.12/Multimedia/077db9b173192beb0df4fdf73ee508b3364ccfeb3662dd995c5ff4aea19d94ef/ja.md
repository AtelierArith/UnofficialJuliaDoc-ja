```julia
pushdisplay(d::AbstractDisplay)
```

新しいディスプレイ `d` をグローバルディスプレイバックエンドスタックの上にプッシュします。 `display(x)` または `display(mime, x)` を呼び出すと、スタック内の最上位の互換性のあるバックエンド（すなわち、[`MethodError`](@ref) をスローしない最上位のバックエンド）で `x` が表示されます。
