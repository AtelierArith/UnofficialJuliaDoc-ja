```julia
issubset(x)
```

引数を `x` と比較する関数を作成します。これは [`issubset`](@ref) を使用し、すなわち `y -> issubset(y, x)` と同等の関数です。返される関数は `Base.Fix2{typeof(issubset)}` 型であり、特化したメソッドを実装するために使用できます。

!!! compat "Julia 1.11"
    この機能は少なくとも Julia 1.11 が必要です。

