```julia
logrange(start, stop, length)
logrange(start, stop; length)
```

与えられた端点の間で対数的に間隔を空けた要素を持つ特化型配列を構築します。つまり、連続する要素の比率は一定で、長さから計算されます。

これはPythonの`geomspace`に似ています。Mathematicaの`PowerRange`とは異なり、比率ではなく要素の数を指定します。PythonやMatlabの`logspace`とは異なり、`start`と`stop`の引数は常に結果の最初と最後の要素であり、いくつかの基数に適用されるべきべき乗ではありません。

# 例

```jldoctest
julia> logrange(10, 4000, length=3)
3-element Base.LogRange{Float64, Base.TwicePrecision{Float64}}:
 10.0, 200.0, 4000.0

julia> ans[2] ≈ sqrt(10 * 4000)  # 中間要素は幾何平均
true

julia> range(10, 40, length=3)[2] ≈ (10 + 40)/2  # 算術平均
true

julia> logrange(1f0, 32f0, 11)
11-element Base.LogRange{Float32, Float64}:
 1.0, 1.41421, 2.0, 2.82843, 4.0, 5.65685, 8.0, 11.3137, 16.0, 22.6274, 32.0

julia> logrange(1, 1000, length=4) ≈ 10 .^ (0:3)
true
```

詳細については[`LogRange`](@ref Base.LogRange)型を参照してください。

線形間隔の点については[`range`](@ref)も参照してください。

!!! compat "Julia 1.11"
    この関数は少なくともJulia 1.11が必要です。

