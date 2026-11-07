```julia
keys(m::RegexMatch)::Vector
```

基になる正規表現のすべてのキャプチャグループについて、キーを返します。キャプチャグループがマッチしなかった場合でも、そのキーは含まれます。つまり、`idx` は、`m[idx] == nothing` の場合でも戻り値に含まれます。

名前のないキャプチャグループには、インデックスに対応する整数キーが割り当てられます。名前付きキャプチャグループには、文字列キーが割り当てられます。

!!! compat "Julia 1.7"
    このメソッドは Julia 1.7 で追加されました


# Examples

```jldoctest
julia> keys(match(r"(?<hour>\d+):(?<minute>\d+)(am|pm)?", "11:30"))
3-element Vector{Any}:
  "hour"
  "minute"
 3
```
