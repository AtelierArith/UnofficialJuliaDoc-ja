```
keys(m::RegexMatch) -> Vector
```

正規表現の基になるキャプチャグループのすべてのキーのベクターを返します。キャプチャグループが一致しなくてもキーは含まれます。つまり、`idx`は`m[idx] == nothing`であっても返り値に含まれます。

名前のないキャプチャグループは、そのインデックスに対応する整数キーを持ちます。名前のあるキャプチャグループは文字列キーを持ちます。

!!! compat "Julia 1.7"
    このメソッドはJulia 1.7で追加されました


# 例

```jldoctest
julia> keys(match(r"(?<hour>\d+):(?<minute>\d+)(am|pm)?", "11:30"))
3-element Vector{Any}:
  "hour"
  "minute"
 3
```
