```julia
isdigit(c::AbstractChar) -> Bool
```

文字がASCIIの10進数の数字（`0`-`9`）であるかどうかをテストします。

関連: [`isletter`](@ref)。

# 例

```jldoctest
julia> isdigit('❤')
false

julia> isdigit('9')
true

julia> isdigit('α')
false
```
