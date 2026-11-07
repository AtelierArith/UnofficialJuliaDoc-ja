```julia
Set{T} <: AbstractSet{T}
```

`Set`は、メンバーシップを高速に判定できる可変コンテナーです。

`Set`では、`in`、`union`、`intersect`などの集合演算が効率的に実装されています。`Set`内の要素は、各要素の`isequal`の定義に従って一意です。`Set`内の要素の順序は実装の詳細であり、依存することはできません。

関連項目: [`AbstractSet`](@ref)、[`BitSet`](@ref)、[`Dict`](@ref)、[`push!`](@ref)、[`empty!`](@ref)、[`union!`](@ref)、[`in`](@ref)、[`isequal`](@ref)

# Examples

```jldoctest; filter = r"^  '.'"ma
julia> s = Set("aaBca")
Set{Char} with 3 elements:
  'a'
  'c'
  'B'

julia> push!(s, 'b')
Set{Char} with 4 elements:
  'a'
  'b'
  'B'
  'c'

julia> s = Set([NaN, 0.0, 1.0, 2.0]);

julia> -0.0 in s # isequal(0.0, -0.0) is false
false

julia> NaN in s # isequal(NaN, NaN) is true
true
```
