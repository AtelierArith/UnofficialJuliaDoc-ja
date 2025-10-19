```julia
string(n::Integer; base::Integer = 10, pad::Integer = 1)
```

整数 `n` を指定された `base` の文字列に変換し、オプションでパディングする桁数を指定します。

関連項目としては [`digits`](@ref), [`bitstring`](@ref), [`count_zeros`](@ref) があります。

# 例

```jldoctest
julia> string(5, base = 13, pad = 4)
"0005"

julia> string(-13, base = 5, pad = 4)
"-0023"
```
