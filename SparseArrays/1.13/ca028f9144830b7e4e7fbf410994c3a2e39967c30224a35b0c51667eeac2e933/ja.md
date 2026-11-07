```julia
sprandn([rng][,Type],m[,n],p::AbstractFloat)
```

長さが`m`のランダムな疎ベクトル、またはサイズが`m` × `n`のランダムな疎行列を作成します。各要素が非ゼロとなる確率は、指定した`p`（各要素について独立）です。非ゼロ値は正規分布からサンプリングされます。省略可能な`rng`引数で乱数生成器を指定できます。詳細は[Random Numbers](@ref)を参照してください。

!!! compat "Julia 1.1"
    出力要素型`Type`の指定には、Julia 1.1以降が必要です。


# Examples

```jldoctest; setup = :(using Random; Random.seed!(0))
julia> sprandn(2, 2, 0.75)
2×2 SparseMatrixCSC{Float64, Int64} with 3 stored entries:
 -1.20577     ⋅
  0.311817  -0.234641
```
