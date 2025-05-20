```
!(x)
```

ブールの否定。 [`missing`](@ref) が `x` が `missing` の場合に返される [三値論理](https://en.wikipedia.org/wiki/Three-valued_logic) を実装しています。

ビット単位の否定については、[`~`](@ref) も参照してください。

# 例

```jldoctest
julia> !true
false

julia> !false
true

julia> !missing
missing

julia> .![true false true]
1×3 BitMatrix:
 0  1  0
```
