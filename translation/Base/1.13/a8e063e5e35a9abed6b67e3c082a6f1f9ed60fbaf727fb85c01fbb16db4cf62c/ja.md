```julia
findall(c::AbstractChar, s::AbstractString)
```

`s` のうち `s[i] == c` を満たす要素のインデックスを格納したベクトル `I` を返します。`s` にそのような要素がない場合は、空の配列を返します。

# Examples

```jldoctest
julia> findall('a', "batman")
2-element Vector{Int64}:
 2
 5
```

!!! compat "Julia 1.7"
    このメソッドには Julia 1.7 以降が必要です。

