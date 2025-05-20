```
isdigit(c::AbstractChar) -> Bool
```

文字が10進数の数字（0-9）であるかどうかをテストします。

参照: [`isletter`](@ref)。

# 例

```jldoctest
julia> isdigit('❤')
false

julia> isdigit('9')
true

julia> isdigit('α')
false
```
