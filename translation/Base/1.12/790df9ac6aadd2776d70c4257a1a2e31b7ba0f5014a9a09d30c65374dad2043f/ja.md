```julia
replace!(new::Union{Function, Type}, A; [count::Integer])
```

コレクション `A` の各要素 `x` を `new(x)` で置き換えます。`count` が指定されている場合、合計で最大 `count` の値を置き換えます（置き換えは `new(x) !== x` と定義されます）。

# 例

```jldoctest
julia> replace!(x -> isodd(x) ? 2x : x, [1, 2, 3, 4])
4-element Vector{Int64}:
 2
 2
 6
 4

julia> replace!(Dict(1=>2, 3=>4)) do kv
           first(kv) < 3 ? first(kv)=>3 : kv
       end
Dict{Int64, Int64} with 2 entries:
  3 => 4
  1 => 3

julia> replace!(x->2x, Set([3, 6]))
Set{Int64} with 2 elements:
  6
  12
```
