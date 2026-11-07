```julia
StableCheckSorted(next) isa Base.Sort.Algorithm
```

入力がソート済みか、逆順にソート済みか、またはその両方かを確認します。

逆順にソート済みとは、隣り合う要素のすべての組について、後の要素が前の要素より小さいことを指します。これは、比較結果が等しい要素の組が入れ替わらないようにするため、`issorted(v, Reverse(o))`よりも厳密な定義です。
