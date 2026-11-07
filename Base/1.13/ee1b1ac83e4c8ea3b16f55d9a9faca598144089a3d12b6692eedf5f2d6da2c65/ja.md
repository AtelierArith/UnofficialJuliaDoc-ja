```julia
in!(x, s::AbstractSet)::Bool
```

`x` が `s` に含まれている場合は、`true` を返します。含まれていない場合は、`x` を `s` にプッシュし、`false` を返します。これは `in(x, s) ? true : (push!(s, x); false)` と同等ですが、より効率的に実装できる場合があります。

関連項目: [`in`](@ref)、[`push!`](@ref)、[`Set`](@ref)

!!! compat "Julia 1.11"
    この関数を使用するには、少なくともバージョン1.11が必要です。


# Examples

```jldoctest; filter = r"^\s+\d$"m
julia> s = Set{Any}([1, 2, 3]); in!(4, s)
false

julia> length(s)
4

julia> in!(0x04, s)
true

julia> s
Set{Any} with 4 elements:
  4
  2
  3
  1
```
