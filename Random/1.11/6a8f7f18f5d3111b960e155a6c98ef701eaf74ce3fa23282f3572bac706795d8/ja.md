```julia
randcycle([rng=default_rng(),] n::Integer)
```

長さ `n` のランダムな巡回置換を構築します。省略可能な引数 `rng` には乱数生成器を指定します。詳細は [Random Numbers](@ref) を参照してください。戻り値の要素型は `n` の型と同じです。

ここで「巡回置換」とは、すべての要素が単一の巡回に含まれる置換を指します。`n > 0` の場合、巡回置換は ``(n-1)!`` 通りあり、いずれも一様に抽出されます。`n == 0` の場合、`randcycle` は空のベクトルを返します。

[`randcycle!`](@ref) は、この関数のインプレース版です。

!!! compat "Julia 1.1"
    Julia 1.1 以降では、`randcycle` は `eltype(v) == typeof(n)` を持つベクトル `v` を返しますが、Julia 1.0 では `eltype(v) == Int` です。


# Examples

```jldoctest
julia> randcycle(Xoshiro(0), 6)
6-element Vector{Int64}:
 5
 1
 4
 6
 3
 2
```
