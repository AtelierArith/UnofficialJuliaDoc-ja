```julia
first(s::AbstractString, n::Integer)
```

`s`の先頭から`n`文字を取り出した文字列を取得します。

# Examples

```jldoctest
julia> first("∀ϵ≠0: ϵ²>0", 0)
""

julia> first("∀ϵ≠0: ϵ²>0", 1)
"∀"

julia> first("∀ϵ≠0: ϵ²>0", 3)
"∀ϵ≠"
```
