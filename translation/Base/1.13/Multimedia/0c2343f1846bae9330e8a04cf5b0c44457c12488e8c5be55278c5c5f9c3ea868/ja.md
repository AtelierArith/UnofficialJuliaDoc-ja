```julia
pushdisplay(d::AbstractDisplay)
```

新しいディスプレイ `d` を、グローバルなディスプレイバックエンドスタックの最上位に追加します。`display(x)` または `display(mime, x)` を呼び出すと、スタック内で最上位にある互換性のあるバックエンド（つまり、[`MethodError`](@ref) をスローしない最上位のバックエンド）に `x` が表示されます。
