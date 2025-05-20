```
CompoundPeriod
```

`CompoundPeriod`は、固定の小さな期間の倍数ではない時間の期間を表現するのに便利です。たとえば、「1年と1日」は固定の数の日ではありませんが、`CompoundPeriod`を使用して表現できます。実際、`CompoundPeriod`は異なる期間タイプの加算によって自動的に生成されます。たとえば、`Year(1) + Day(1)`は`CompoundPeriod`の結果を生成します。
