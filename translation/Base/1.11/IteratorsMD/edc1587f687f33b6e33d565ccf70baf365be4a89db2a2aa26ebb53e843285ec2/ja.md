```
(:)(start::CartesianIndex, [step::CartesianIndex], stop::CartesianIndex)
```

[`CartesianIndices`](@ref)を2つの`CartesianIndex`とオプションのステップから構築します。

!!! compat "Julia 1.1"
    このメソッドは少なくともJulia 1.1が必要です。


!!! compat "Julia 1.6"
    ステップ範囲メソッドstart:step:stopは少なくともJulia 1.6が必要です。


# 例

```jldoctest
julia> I = CartesianIndex(2,1);

julia> J = CartesianIndex(3,3);

julia> I:J
CartesianIndices((2:3, 1:3))

julia> I:CartesianIndex(1, 2):J
CartesianIndices((2:1:3, 1:2:3))
```
