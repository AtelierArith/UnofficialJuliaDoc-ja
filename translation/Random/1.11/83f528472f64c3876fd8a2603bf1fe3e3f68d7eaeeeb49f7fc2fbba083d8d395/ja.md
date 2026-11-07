```julia
randperm([rng=default_rng(),] n::Integer)
```

長さ `n` のランダムな順列を生成します。省略可能な引数 `rng` には、乱数生成器を指定します（[Random Numbers](@ref) を参照）。結果の要素型は `n` の型と同じです。

任意のベクトルをランダムに並べ替えるには、[`shuffle`](@ref) または [`shuffle!`](@ref) を参照してください。

!!! compat "Julia 1.1"
    Julia 1.1 では、`randperm` は `eltype(v) == typeof(n)` を持つベクトル `v` を返しますが、Julia 1.0 では `eltype(v) == Int` です。


# Examples

```jldoctest
julia> randperm(Xoshiro(0), 6)
6-element Vector{Int64}:
 5
 1
 2
 6
 3
 4
```
