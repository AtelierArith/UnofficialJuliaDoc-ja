```julia
StepRange{T, S} <: OrdinalRange{T, S}
```

要素の型が`T`で、間隔の型が`S`の範囲です。各要素間のステップは一定で、範囲は型が`T`の`start`と`stop`、および型が`S`の`step`で定義されます。`T`も`S`も、浮動小数点型にしてはいけません。`b != 0`、`a`、`b`、`c`がすべて整数である`a:b:c`という構文は、`StepRange`を作成します。

# Examples

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
