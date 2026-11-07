```julia
struct OverlayMethodTable <: MethodTableView
```

内部メソッドテーブルにオーバーレイし、特定のクエリを外部テーブルに転送できるようにします。たとえば、既存のメソッドをオーバーライドする場合に使用します。
