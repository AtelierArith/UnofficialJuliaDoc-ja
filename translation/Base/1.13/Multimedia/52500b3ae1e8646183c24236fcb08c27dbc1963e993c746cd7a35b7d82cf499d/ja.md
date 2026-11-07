```julia
popdisplay()
popdisplay(d::AbstractDisplay)
```

ディスプレイバックエンドのスタックから最上位のバックエンドを取り出します。2つ目のバリアントでは、`d`の最上位のコピーを取り出します。
