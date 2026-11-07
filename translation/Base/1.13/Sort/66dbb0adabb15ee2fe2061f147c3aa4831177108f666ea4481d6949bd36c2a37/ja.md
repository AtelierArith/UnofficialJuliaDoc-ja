```julia
ConsiderRadixSort(radix=RadixSort(), next) isa Base.Sort.Algorithm
```

入力の範囲のビット数が十分に小さく、入力が効率的なビットシフトをサポートしている場合は、`radix`アルゴリズムを使用します。それ以外の場合は、`next`アルゴリズムに処理を委譲します。
