```julia
iscntrl(c::AbstractChar)::Bool
```

文字が制御文字かどうかを判定します。制御文字とは、Unicode の Latin-1 サブセットに含まれる非表示文字です。

# Examples

```jldoctest
julia> iscntrl('\x01')
true

julia> iscntrl('a')
false
```
