```julia
last(s::AbstractString, n::Integer)
```

文字列 `s` の最後の `n` 文字からなる文字列を取得します。

# 例

```jldoctest
julia> last("∀ϵ≠0: ϵ²>0", 0)
""

julia> last("∀ϵ≠0: ϵ²>0", 1)
"0"

julia> last("∀ϵ≠0: ϵ²>0", 3)
"²>0"
```
