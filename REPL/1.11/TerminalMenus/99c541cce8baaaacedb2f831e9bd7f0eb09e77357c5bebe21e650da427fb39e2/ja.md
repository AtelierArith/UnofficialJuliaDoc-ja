```julia
request(m::AbstractMenu; cursor=1)
```

メニューを表示し、インタラクティブモードに入ります。`cursor`は初期カーソル位置に使用されるアイテム番号を示します。`cursor`は`Int`または`RefValue{Int}`のいずれかであることができます。後者は外部からカーソル位置の観察と制御に便利です。

`selected(m)`を返します。

!!! compat "Julia 1.6"
    `cursor`引数はJulia 1.6以降が必要です。

