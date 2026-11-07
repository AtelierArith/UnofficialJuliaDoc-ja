```julia
pick(m::AbstractMenu, cursor::Int)
```

メニューが開いているときにユーザーが Enter キーを押した場合の動作を定義します。`true` が返されると、`request()` は終了します。`cursor` は選択位置のインデックスです。
