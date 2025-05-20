```
x & y
```

ビット単位のAND。 [三値論理](https://en.wikipedia.org/wiki/Three-valued_logic)を実装しており、片方のオペランドが`missing`で、もう片方が`true`の場合は[`missing`](@ref)を返します。関数適用形式のために括弧を追加します: `(&)(x, y)`。

関連項目: [`|`](@ref), [`xor`](@ref), [`&&`](@ref)。

# 例

```jldoctest
julia> 4 & 10
0

julia> 4 & 12
4

julia> true & missing
missing

julia> false & missing
false
```
