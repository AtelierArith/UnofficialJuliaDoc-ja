```julia
sprand([rng],[T::Type],m,[n],p::AbstractFloat)
sprand([rng],m,[n],p::AbstractFloat,[rfn=rand])
```

ランダムな長さの `m` 疎ベクトル、または `m` × `n` の疎行列を作成します。各要素が非ゼロになる確率は独立に `p` で与えられます（したがって、非ゼロ要素の平均密度も正確に `p` です）。省略可能な `rng` 引数では乱数生成器を指定します。詳しくは [Random Numbers](@ref) を参照してください。省略可能な `T` 引数では要素の型を指定します。既定値は `Float64` です。

既定では、非ゼロ値は [`rand`](@ref) 関数を使って一様分布からサンプリングされます。つまり、`rand(T)` によってサンプリングされます。`rng` が指定されている場合は `rand(rng, T)` によってサンプリングされます。既定の `T=Float64` では、これは `[0,1)` から一様にサンプリングされた非ゼロ値に相当します。

`rand` の代わりにカスタムの `rfn` 関数を渡すと、別の分布から非ゼロ値をサンプリングできます。この関数は、目的の分布からサンプリングした `k` 個の乱数を含む配列を返す関数 `rfn(k)` である必要があります。また、`rng` が指定されている場合は、代わりに関数 `rfn(rng, k)` である必要があります。

# Examples

```jldoctest; setup = :(using Random; Random.seed!(1234))
julia> sprand(Bool, 2, 2, 0.5)
2×2 SparseMatrixCSC{Bool, Int64} with 2 stored entries:
 1  1
 ⋅  ⋅

julia> sprand(Float64, 3, 0.75)
3-element SparseVector{Float64, Int64} with 2 stored entries:
  [1]  =  0.795547
  [2]  =  0.49425
```
