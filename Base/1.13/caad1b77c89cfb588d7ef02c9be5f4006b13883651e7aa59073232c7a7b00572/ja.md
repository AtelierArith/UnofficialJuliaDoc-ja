```julia
last(s::AbstractString, n::Integer)
```

`s` の末尾 `n` 文字からなる文字列を取得します。

# Examples

```jldoctest
julia> last("∀ϵ≠0: ϵ²>0", 0)
""

julia> last("∀ϵ≠0: ϵ²>0", 1)
"0"

julia> last("∀ϵ≠0: ϵ²>0", 3)
"²>0"
```
