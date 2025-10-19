```julia
Set{T} <: AbstractSet{T}
```

`Set`は、迅速なメンバーシップテストを提供する可変コンテナです。

`Set`は、`in`、`union`、`intersect`などの集合演算の効率的な実装を持っています。`Set`内の要素は、要素の`isequal`の定義によって決定されるユニークなものです。`Set`内の要素の順序は実装の詳細であり、信頼することはできません。

参照: [`AbstractSet`](@ref), [`BitSet`](@ref), [`Dict`](@ref), [`push!`](@ref), [`empty!`](@ref), [`union!`](@ref), [`in`](@ref), [`isequal`](@ref)

# 例

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
