```julia
ispunct(c::AbstractChar)::Bool
```

文字が Unicode の一般カテゴリ「句読点」に属するかどうかを判定します。つまり、カテゴリコードが「P」で始まる文字かどうかを調べます。

!!! note
    この動作は、C の `ispunct` 関数とは異なります。


# Examples

```jldoctest
julia> ispunct('α')
false

julia> ispunct('=')
false

julia> ispunct('/')
true

julia> ispunct(';')
true
```
