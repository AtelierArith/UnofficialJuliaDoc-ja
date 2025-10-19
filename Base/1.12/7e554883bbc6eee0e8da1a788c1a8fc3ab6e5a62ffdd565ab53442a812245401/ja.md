```julia
ndigits(n::Integer; base::Integer=10, pad::Integer=1)
```

整数 `n` の桁数を、基数 `base` で表現した場合に計算します（`base` は `[-1, 0, 1]` であってはいけません）。オプションで、指定されたサイズにゼロでパディングすることができます（結果は決して `pad` より小さくなりません）。

関連情報として [`digits`](@ref)、[`count_ones`](@ref) を参照してください。

# 例

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
