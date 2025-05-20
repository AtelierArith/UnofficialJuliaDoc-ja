```
issetequal(x)
```

引数を `x` と比較する関数を作成します。これは [`issetequal`](@ref) を使用します。すなわち、`y -> issetequal(y, x)` に相当する関数です。返される関数は `Base.Fix2{typeof(issetequal)}` 型であり、特化したメソッドを実装するために使用できます。

!!! compat "Julia 1.11"
    この機能は少なくとも Julia 1.11 が必要です。

