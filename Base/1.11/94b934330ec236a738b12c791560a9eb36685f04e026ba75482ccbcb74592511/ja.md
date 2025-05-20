```
findall(c::AbstractChar, s::AbstractString)
```

`s`の中で`s[i] == c`となるインデックスのベクトル`I`を返します。`s`にそのような要素がない場合は、空の配列を返します。

# 例

```jldoctest
julia> findall('a', "batman")
2-element Vector{Int64}:
 2
 5
```

!!! compat "Julia 1.7"
    このメソッドは少なくともJulia 1.7が必要です。

