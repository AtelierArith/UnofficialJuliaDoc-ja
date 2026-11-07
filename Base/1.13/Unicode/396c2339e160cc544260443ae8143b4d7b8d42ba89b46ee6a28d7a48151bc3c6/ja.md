```julia
isdigit(c::AbstractChar)::Bool
```

文字が ASCII の十進数字かどうかを判定します（`0`-`9`）。

関連項目：[`isletter`](@ref)。

# Examples

```jldoctest
julia> isdigit('❤')
false

julia> isdigit('9')
true

julia> isdigit('α')
false
```
