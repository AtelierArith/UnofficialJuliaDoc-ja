```julia
struct OverlayMethodTable <: MethodTableView
```

内部メソッドテーブルにオーバーレイを適用し、特定のクエリを外部テーブルに転送できるようにします。たとえば、既存のメソッドをオーバーライドする場合に使用します。
