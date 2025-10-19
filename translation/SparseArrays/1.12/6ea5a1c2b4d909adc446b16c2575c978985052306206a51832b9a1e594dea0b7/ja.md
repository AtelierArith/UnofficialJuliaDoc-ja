```julia
sprandn([rng][,Type],m[,n],p::AbstractFloat)
```

長さ `m` のランダムスパースベクトルまたはサイズ `m` x `n` のスパース行列を作成し、任意のエントリが非ゼロである確率 `p` を指定します。非ゼロの値は正規分布からサンプリングされます。オプションの `rng` 引数は乱数生成器を指定します。詳細は [Random Numbers](@ref) を参照してください。

!!! compat "Julia 1.1"
    出力要素型 `Type` を指定するには、少なくとも Julia 1.1 が必要です。


# 例

```jldoctest; setup = :(using Random; Random.seed!(0))
julia> sprandn(2, 2, 0.75)
2×2 SparseMatrixCSC{Float64, Int64} with 3 stored entries:
 -1.20577     ⋅
  0.311817  -0.234641
```
