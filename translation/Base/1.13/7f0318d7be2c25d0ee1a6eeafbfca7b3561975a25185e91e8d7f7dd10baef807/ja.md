```julia
isdisjoint(x)
```

引数を `x` と比較する関数を、[`isdisjoint`](@ref) を使って作成します。つまり、`y -> isdisjoint(y, x)` と同等の関数です。返される関数の型は `Base.Fix2{typeof(isdisjoint)}` で、これを使って特化メソッドを実装できます。

!!! compat "Julia 1.11"
    この機能を利用するには、Julia 1.11 以降が必要です。

