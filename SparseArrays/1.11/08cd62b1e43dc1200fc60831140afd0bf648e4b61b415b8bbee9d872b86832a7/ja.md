```
sprand([rng],[T::Type],m,[n],p::AbstractFloat)
sprand([rng],m,[n],p::AbstractFloat,[rfn=rand])
```

ランダムな長さ `m` のスパースベクトルまたは `m` x `n` のスパース行列を作成します。この行列では、任意の要素が非ゼロである確率は独立して `p` によって与えられ（したがって、非ゼロの平均密度も正確に `p` になります）。オプションの `rng` 引数は乱数生成器を指定し、[Random Numbers](@ref)を参照してください。オプションの `T` 引数は要素の型を指定し、デフォルトは `Float64` です。

デフォルトでは、非ゼロの値は一様分布からサンプリングされ、[`rand`](@ref) 関数を使用します。つまり、`rand(T)` または `rng` が指定されている場合は `rand(rng, T)` になります。デフォルトの `T=Float64` の場合、これは `[0,1)` の範囲で一様にサンプリングされた非ゼロの値に対応します。

異なる分布から非ゼロの値をサンプリングするには、`rand` の代わりにカスタム `rfn` 関数を渡します。この関数は `rfn(k)` という形式で、希望する分布からサンプリングされた `k` 個の乱数の配列を返す必要があります。あるいは、`rng` が指定されている場合は、`rfn(rng, k)` という形式の関数である必要があります。

# 例

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
