```julia
pick(m::AbstractMenu, cursor::Int)
```

メニューが開いているときにユーザーがEnterキーを押したときに何が起こるかを定義します。`true`が返されると、`request()`は終了します。`cursor`は選択の位置をインデックスします。
