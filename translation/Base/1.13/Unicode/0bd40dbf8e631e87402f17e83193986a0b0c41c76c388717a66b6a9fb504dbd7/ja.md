```julia
isprint(c::AbstractChar)::Bool
```

制御文字ではなく、空白を含む印字可能な文字かどうかを判定します。

# Examples

```jldoctest
julia> isprint('\x01')
false

julia> isprint('A')
true
```
