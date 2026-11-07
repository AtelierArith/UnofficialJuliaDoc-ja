```julia
InitialOptimizations(next) isa Base.Sort.Algorithm
```

ソートする前に、入力ベクトルに対して低コストな最適化をいくつか試みます。これらの最適化は、`sort!` ファミリーの関数に引数として `alg=InsertionSort`、`alg=MergeSort`、または `alg=QuickSort` を渡すと、自動的に適用される場合があります。

`InitialOptimizations` は実装の詳細であり、今後の Julia のバージョンで変更または削除される可能性があります。

`next` が安定している場合、`InitialOptimizations(next)` も安定しています。

`InitialOptimizations` が試みる具体的な最適化は、[`SubArrayOptimization`](@ref)、[`MissingOptimization`](@ref)、[`BoolOptimization`](@ref)、`length <= 10` を含む入力に対する [`InsertionSort`](@ref) へのディスパッチ、および [`IEEEFloatOptimization`](@ref) です。
