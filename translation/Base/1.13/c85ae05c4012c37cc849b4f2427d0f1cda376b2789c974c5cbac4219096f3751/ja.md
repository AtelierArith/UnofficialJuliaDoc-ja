```julia
replace(new::Union{Function, Type}, A; [count::Integer])
```

`A` 内の各 `x` を `new(x)` に置き換えた `A` のコピーを返します。`count` が指定されている場合、置き換える値の合計は最大 `count` 個です（置換とは `new(x) !== x` と定義されます）。

!!! compat "Julia 1.7"
    `Tuple` の要素を置き換えるには、バージョン 1.7 が必要です。


# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
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
