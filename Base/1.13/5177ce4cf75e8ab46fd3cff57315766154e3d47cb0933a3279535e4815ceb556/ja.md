```julia
ndigits(n::Integer; base::Integer=10, pad::Integer=1)
```

整数 `n` を `base` 進数で表したときの桁数を計算します（`base` は `[-1, 0, 1]` に含まれていてはなりません）。必要に応じて、指定した桁数になるようゼロで埋めることもできます（結果が `pad` 未満になることはありません）。

関連項目: [`digits`](@ref)、[`count_ones`](@ref)。

# Examples

```jldoctest
julia> ndigits(0)
1

julia> ndigits(12345)
5

julia> ndigits(1022, base=16)
3

julia> string(1022, base=16)
"3fe"

julia> ndigits(123, pad=5)
5

julia> ndigits(-123)
3
```
