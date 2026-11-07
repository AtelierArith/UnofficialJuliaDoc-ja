```julia
shuffle([rng=default_rng(),] v::Union{NTuple,AbstractArray})
```

`v`の要素をランダムに並べ替えたコピーを返します。省略可能な引数`rng`では、乱数生成器を指定します（[Random Numbers](@ref)を参照）。`v`をインプレースで並べ替える方法については、[`shuffle!`](@ref)を参照してください。ランダムに並べ替えたインデックスを取得する方法については、[`randperm`](@ref)を参照してください。

!!! compat "Julia 1.13"
    `NTuple`の値をシャッフルするには、Julia v1.13以降が必要です。


# Examples

```jldoctest
julia> shuffle(Xoshiro(0), 1:6)
6-element Vector{Int64}:
 5
 1
 2
 6
 3
 4
```
