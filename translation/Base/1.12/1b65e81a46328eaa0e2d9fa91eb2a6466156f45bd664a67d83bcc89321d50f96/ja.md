```julia
replace(new::Union{Function, Type}, A; [count::Integer])
```

`A`の各値`x`を`new(x)`で置き換えたコピーを返します。`count`が指定されている場合、合計で最大`count`の値を置き換えます（置き換えは`new(x) !== x`として定義されます）。

!!! compat "Julia 1.7"
    `Tuple`の要素を置き換えるにはバージョン1.7が必要です。


# 例

```jldoctest
julia> replace(x -> isodd(x) ? 2x : x, [1, 2, 3, 4])
4-element Vector{Int64}:
 2
 2
 6
 4

julia> replace(Dict(1=>2, 3=>4)) do kv
           first(kv) < 3 ? first(kv)=>3 : kv
       end
Dict{Int64, Int64} with 2 entries:
  3 => 4
  1 => 3
```
