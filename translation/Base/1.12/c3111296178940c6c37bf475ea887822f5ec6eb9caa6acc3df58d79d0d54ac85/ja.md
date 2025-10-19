```julia
isdisjoint(x)
```

引数を `x` と比較する関数を作成します。これは [`isdisjoint`](@ref) を使用し、すなわち `y -> isdisjoint(y, x)` と同等の関数です。返される関数は `Base.Fix2{typeof(isdisjoint)}` 型であり、特化したメソッドを実装するために使用できます。

!!! compat "Julia 1.11"
    この機能は少なくとも Julia 1.11 が必要です。

