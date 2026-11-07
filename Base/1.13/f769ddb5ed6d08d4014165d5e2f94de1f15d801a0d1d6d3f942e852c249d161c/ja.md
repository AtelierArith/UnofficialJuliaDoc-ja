```julia
accumulate(op, A; dims::Integer, [init])
```

`op` を `A` の `dims` 次元に沿って累積します（ベクトルの場合、`dims` は省略可能です）。キーワード引数で初期値 `init` を指定することもできます。パフォーマンスの向上や、出力の精度を制御する（たとえばオーバーフローを避ける）ために、事前に確保した出力配列を使う方法については [`accumulate!`](@ref) も参照してください。

一般的な操作には、`accumulate` の専用バリアントがあります。[`cumsum`](@ref)、[`cumprod`](@ref) を参照してください。遅延評価版については [`Iterators.accumulate`](@ref) を参照してください。

!!! compat "Julia 1.5"
    配列ではないイテレータに対する `accumulate` の使用には、Julia 1.5 以降が必要です。


# Examples

```jldoctest
julia> accumulate(+, [1,2,3])
3-element Vector{Int64}:
 1
 3
 6

julia> accumulate(min, (1, -2, 3, -4, 5), init=0)
(0, -2, -2, -4, -4)

julia> accumulate(/, (2, 4, Inf), init=100)
(50.0, 12.5, 0.0)

julia> accumulate(=>, i^2 for i in 1:3)
3-element Vector{Any}:
          1
        1 => 4
 (1 => 4) => 9

julia> accumulate(+, fill(1, 3, 4))
3×4 Matrix{Int64}:
 1  4  7  10
 2  5  8  11
 3  6  9  12

julia> accumulate(+, fill(1, 2, 5), dims=2, init=100.0)
2×5 Matrix{Float64}:
 101.0  102.0  103.0  104.0  105.0
 101.0  102.0  103.0  104.0  105.0
```
