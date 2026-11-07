```julia
ConsiderRadixSort(radix=RadixSort(), next) isa Base.Sort.Algorithm
```

入力の範囲に含まれるビット数が十分に少なく、入力が効率的なビットシフトをサポートしている場合は、`radix`アルゴリズムを使用します。それ以外の場合は、`next`アルゴリズムにディスパッチします。
