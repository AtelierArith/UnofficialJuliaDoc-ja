```julia
x | y
```

ビット単位の論理和。片方のオペランドが `missing` で、もう片方が `false` の場合は [`missing`](@ref) を返す [三値論理](https://en.wikipedia.org/wiki/Three-valued_logic) を実装しています。

関連: [`&`](@ref), [`xor`](@ref), [`||`](@ref).

# 例

```jldoctest
julia> 4 | 10
14

julia> 4 | 1
5

julia> true | missing
true

julia> false | missing
missing
```
