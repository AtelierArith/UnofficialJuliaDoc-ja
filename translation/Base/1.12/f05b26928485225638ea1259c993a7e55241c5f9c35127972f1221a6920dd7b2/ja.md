```julia
isapprox(x; kwargs...) / ≈(x; kwargs...)
```

引数を `x` と比較する関数を作成します。つまり、`y -> y ≈ x` に相当する関数です。

ここでサポートされているキーワード引数は、2引数の `isapprox` と同じです。

!!! compat "Julia 1.5"
    このメソッドは Julia 1.5 以降が必要です。

