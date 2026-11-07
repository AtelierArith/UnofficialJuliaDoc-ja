```julia
issubset(x)
```

引数を `x` と比較する関数を、[`issubset`](@ref) を使って作成します。これは、`y -> issubset(y, x)` と同等の関数です。返される関数の型は `Base.Fix2{typeof(issubset)}` で、これを使って特化したメソッドを実装できます。

!!! compat "Julia 1.11"
    この機能を使うには、Julia 1.11 以降が必要です。

