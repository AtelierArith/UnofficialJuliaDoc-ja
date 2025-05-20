```
accumulate(op, A; dims::Integer, [init])
```

累積操作 `op` を `A` の次元 `dims` に沿って実行します（ベクトルの場合、`dims` はオプションです）。初期値 `init` はキーワード引数としてオプションで提供できます。出力の精度を制御し（例えば、オーバーフローを避けるために）、パフォーマンスのために事前に割り当てられた出力配列を使用するには、[`accumulate!`](@ref) も参照してください。

一般的な操作には、[`cumsum`](@ref) や [`cumprod`](@ref) のような専門的なバリアントがあります。遅延バージョンについては、[`Iterators.accumulate`](@ref) を参照してください。

!!! compat "Julia 1.5"
    非配列イテレータに対する `accumulate` は、少なくとも Julia 1.5 が必要です。


# 例

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
