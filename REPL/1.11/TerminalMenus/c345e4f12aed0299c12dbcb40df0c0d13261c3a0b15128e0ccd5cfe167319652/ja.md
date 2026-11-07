```julia
request(m::AbstractMenu; cursor=1)
```

メニューを表示して、対話モードに入ります。`cursor`は、初期カーソル位置に使用する項目番号を示します。`cursor`には、`Int`または`RefValue{Int}`を指定できます。後者を使うと、外部からカーソル位置を監視および制御できます。

`selected(m)`を返します。

!!! compat "Julia 1.6"
    `cursor`引数を使用するには、Julia 1.6以降が必要です。

