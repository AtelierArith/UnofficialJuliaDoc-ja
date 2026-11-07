```julia
logrange(start, stop, length)
logrange(start, stop; length)
```

指定された両端の間に、要素が対数間隔で並ぶ特殊な配列を構築します。つまり、隣り合う要素の比は一定で、その値は配列の長さから計算されます。

Python の `geomspace` に似ています。Mathematica の `PowerRange` とは異なり、比ではなく要素数を指定します。また、Python や Matlab の `logspace` とは異なり、引数 `start` と `stop` は、何らかの底に適用する指数ではなく、常に結果の最初と最後の要素を表します。

# Examples

```jldoctest
julia> logrange(10, 4000, length=3)
3-element Base.LogRange{Float64, Base.TwicePrecision{Float64}}:
 10.0, 200.0, 4000.0

julia> ans[2] ≈ sqrt(10 * 4000)  # middle element is the geometric mean
true

julia> range(10, 40, length=3)[2] ≈ (10 + 40)/2  # arithmetic mean
true

julia> logrange(1f0, 32f0, 11)
11-element Base.LogRange{Float32, Float64}:
 1.0, 1.41421, 2.0, 2.82843, 4.0, 5.65685, 8.0, 11.3137, 16.0, 22.6274, 32.0

julia> logrange(1, 1000, length=4) ≈ 10 .^ (0:3)
true
```

詳しくは、型 [`LogRange`](@ref Base.LogRange) を参照してください。

線形間隔の点については、[`range`](@ref) も参照してください。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。

