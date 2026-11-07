```julia
extrema(f, A::AbstractArray; dims) -> Array{Tuple}
```

指定された `A` の各要素に `f` を適用し、その最小値と最大値を計算します。

!!! compat "Julia 1.2"
    このメソッドを使用するには、Julia 1.2 以降が必要です。

