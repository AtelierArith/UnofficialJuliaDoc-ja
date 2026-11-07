```julia
CompoundPeriod
```

`CompoundPeriod`は、より小さな期間の固定倍数ではない期間を表すのに便利です。たとえば、「1年と1日」は日数の固定値ではありませんが、`CompoundPeriod`を使って表現できます。実際、異なる種類の期間を加算すると、`CompoundPeriod`が自動的に生成されます。たとえば、`Year(1) + Day(1)`の結果は`CompoundPeriod`になります。
