```julia
popdisplay()
popdisplay(d::AbstractDisplay)
```

ディスプレイバックエンドのスタックから最上位のバックエンドを取り出します。2つ目の形式では、`d` の最上位のコピーを取り出します。
