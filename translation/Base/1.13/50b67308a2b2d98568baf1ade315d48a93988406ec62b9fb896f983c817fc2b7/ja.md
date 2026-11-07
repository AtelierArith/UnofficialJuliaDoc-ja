```julia
string(n::Integer; base::Integer = 10, pad::Integer = 1)
```

整数 `n` を、指定した `base` の文字列に変換します。必要に応じて、ゼロ埋めする桁数も指定できます。

[`digits`](@ref)、[`bitstring`](@ref)、[`count_zeros`](@ref)、および標準ライブラリの Printf も参照してください。

# Examples

```jldoctest
julia> string(5, base = 13, pad = 4)
"0005"

julia> string(-13, base = 5, pad = 4)
"-0023"

julia> using Printf

julia> @sprintf("%04i", 5)
"0005"

julia> @sprintf("%4i", 5)
"   5"
```
