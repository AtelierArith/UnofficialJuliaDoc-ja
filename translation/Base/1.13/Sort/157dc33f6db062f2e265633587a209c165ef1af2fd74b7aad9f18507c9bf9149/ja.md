```julia
ConsiderCountingSort(counting=CountingSort(), next) isa Base.Sort.Algorithm
```

入力の範囲が十分に小さい場合は、`counting`アルゴリズムを使用します。それ以外の場合は、`next`アルゴリズムに処理を委譲します。

ほとんどの型では、範囲の長さが全体の半分未満であることがしきい値になります。ただし、Int64より大きい型ではビットシフトのコストが高く、RadixSortも実用的ではないため、しきい値はかなり緩やかに設定されています。
