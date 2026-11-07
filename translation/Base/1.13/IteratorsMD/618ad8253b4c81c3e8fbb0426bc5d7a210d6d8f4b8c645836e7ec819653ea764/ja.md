```julia
(:)(start::CartesianIndex, [step::CartesianIndex], stop::CartesianIndex)
```

2つの`CartesianIndex`と省略可能なステップから[`CartesianIndices`](@ref)を構築します。

!!! compat "Julia 1.1"
    このメソッドを使用するには、Julia 1.1以降が必要です。


!!! compat "Julia 1.6"
    ステップ範囲メソッド start:step:stop を使用するには、Julia 1.6以降が必要です。


# Examples

```jldoctest
julia> I = CartesianIndex(2,1);

julia> J = CartesianIndex(3,3);

julia> I:J
CartesianIndices((2:3, 1:3))

julia> I:CartesianIndex(1, 2):J
CartesianIndices((2:1:3, 1:2:3))
```
