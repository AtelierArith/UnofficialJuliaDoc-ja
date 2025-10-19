```julia
in!(x, s::AbstractSet) -> Bool
```

`s`に`x`が含まれている場合は`true`を返します。そうでない場合は、`x`を`s`に追加して`false`を返します。これは`in(x, s) ? true : (push!(s, x); false)`と同等ですが、より効率的な実装がされている可能性があります。

参照: [`in`](@ref), [`push!`](@ref), [`Set`](@ref)

!!! compat "Julia 1.11"
    この関数は少なくとも1.11が必要です。


# 例

```jldoctest; filter = r"^  [1234]$"
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
