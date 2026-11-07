```julia
findall(c::AbstractChar, s::AbstractString)
```

`s` 内に該当する要素がない場合は、空の配列を返します。そうでない場合は、`s[i] == c` を満たす `s` のインデックスを格納した `I` を返します。

# Examples

```jldoctest
julia> findall('a', "batman")
2-element Vector{Int64}:
 2
 5
```

!!! compat "Julia 1.7"
    このメソッドを使用するには、Julia 1.7 以降が必要です。

