```julia
x & y
```

ビット単位のAND。 [三値論理](https://en.wikipedia.org/wiki/Three-valued_logic)を実装しており、一方のオペランドが`missing`で他方が`true`の場合は[`missing`](@ref)を返します。関数適用形式のために括弧を追加します: `(&)(x, y)`。

参照: [`|`](@ref), [`xor`](@ref), [`&&`](@ref)。

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
