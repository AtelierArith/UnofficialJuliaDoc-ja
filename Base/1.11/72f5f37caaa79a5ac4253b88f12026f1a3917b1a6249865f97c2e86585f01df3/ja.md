```
StepRange{T, S} <: OrdinalRange{T, S}
```

要素の型 `T` と間隔の型 `S` を持つ範囲。各要素間のステップは一定で、範囲は型 `T` の `start` と `stop`、および型 `S` の `step` に基づいて定義されます。`T` も `S` も浮動小数点型であってはなりません。`a:b:c` という構文は、`b != 0` であり、`a`、`b`、`c` がすべて整数である場合に `StepRange` を作成します。

# 例

```jldoctest
julia> collect(StepRange(1, Int8(2), 10))
5-element Vector{Int64}:
 1
 3
 5
 7
 9

julia> typeof(StepRange(1, Int8(2), 10))
StepRange{Int64, Int8}

julia> typeof(1:3:6)
StepRange{Int64, Int64}
```
