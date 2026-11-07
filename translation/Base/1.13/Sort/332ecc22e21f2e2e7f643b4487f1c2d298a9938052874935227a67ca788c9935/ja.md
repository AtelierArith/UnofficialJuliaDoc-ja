```julia
ComputeExtrema(next) isa Base.Sort.Algorithm
```

指定された順序に従って、入力の最小値と最大値を求めます。

最小値が最大値以上であれば、入力はすでにソートされています。そうでなければ、`next` アルゴリズムに処理を委譲します。
